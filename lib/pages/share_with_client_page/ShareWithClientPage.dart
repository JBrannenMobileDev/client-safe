
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../navigation/routes/RouteNames.dart';
import '../../utils/Shadows.dart';
import '../../widgets/DandyLightTextField.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';
import 'ShareWithClientTextField.dart';

class ShareWithClientPage extends StatefulWidget {
  final Job job;
  ShareWithClientPage({this.job});

  @override
  State<StatefulWidget> createState() {
    return _ShareWithClientPageState(job);
  }
}

class _ShareWithClientPageState extends State<ShareWithClientPage> with TickerProviderStateMixin {
  final Job job;
  Profile profile;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  _ShareWithClientPageState(this.job);

  void handleClick(String value) {
    switch (value) {
      case 'Branding':
        NavigationUtil.onEditBrandingSelected(context);
        break;
      case 'Business Info':
        NavigationUtil.onEditProfileSelected(context, profile);
        break;
      case 'Payment Options':
        NavigationUtil.onPaymentRequestInfoSelected(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ShareWithClientPageState>(
        onInit: (store) async {
          await store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));
          store.dispatch(SetJobShareWithClientAction(store.state.shareWithClientPageState, job));
          profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
          String clientMessage = "Hi ${job.client.firstName},\nI\'m so excited to book in your photoshoot! Let\'s make this official.\n\nTo lock in your date, please review and sign the contract and pay the deposit.\n\nChat soon";
          messageController.value = messageController.value.copyWith(text: profile.clientMessage.isNotEmpty ? profile.clientMessage : clientMessage);
          if(profile.clientMessage.isEmpty) {
            store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, clientMessage));
          }
        },
        onWillChange: (previous, current) {
          setState(() {
            profile = current.profile;
          });
        },
        converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
        builder: (BuildContext context, ShareWithClientPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    pinned: true,
                    centerTitle: true,
                    title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Share With Client",
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: handleClick,
                        padding: EdgeInsets.only(right: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        itemBuilder: (BuildContext context) {
                          return {'Branding', 'Business Info', 'Payment Options'}.map((String choice) {
                            Widget icon = SizedBox();
                            switch (choice) {
                              case 'Branding':
                                icon = Image.asset('assets/images/icons/art.png');
                                break;
                              case 'Business Info':
                                icon = Image.asset('assets/images/icons/profile_icon_black.png');
                                break;
                              case 'Payment Options':
                                icon = Image.asset('assets/images/collection_icons/pricing_profile_icons/wallet_icon_white.png', color: Color(ColorConstants.getPrimaryBlack()),);
                                break;
                            }
                            icon = Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 18.0, left: 2.0),
                                  height: 28.0,
                                  width: 28.0,
                                  child: icon,
                                );
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  icon,
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: choice,
                                  )
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        profile != null && !profile.hasSetupBrand ? Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              NavigationUtil.onEditBrandingSelected(context);
                            },
                            child: Container(
                              width: 264,
                              height: 54,
                              margin: EdgeInsets.only(top: 16, bottom: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPeachDark()),
                                borderRadius: BorderRadius.circular(27),
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Setup Branding',
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                        profile != null && !profile.hasSetupBrand ? Container(
                          padding: EdgeInsets.only(left: 64, right: 64),
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            textAlign: TextAlign.center,
                            text: 'Branding will be used to customize your client portal.',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ) : SizedBox(),
                        profile != null && !profile.isProfileComplete() ? Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              NavigationUtil.onEditProfileSelected(context, profile);
                            },
                            child: Container(
                              width: 264,
                              height: 54,
                              margin: EdgeInsets.only(top: 32, bottom: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPeachDark()),
                                borderRadius: BorderRadius.circular(27),
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Setup Business Info',
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                        profile != null && !profile.isProfileComplete() ? Container(
                          padding: EdgeInsets.only(left: 64, right: 64),
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            textAlign: TextAlign.center,
                            text: 'Business info is used in the client portal to share your contact information.',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ) : SizedBox(),
                        profile != null && !profile.paymentOptionsSelected() ? Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              NavigationUtil.onPaymentRequestInfoSelected(context);
                            },
                            child: Container(
                              width: 264,
                              height: 54,
                              margin: EdgeInsets.only(top: 32, bottom: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPeachDark()),
                                borderRadius: BorderRadius.circular(27),
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Setup Payment Options',
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                        profile != null && !profile.paymentOptionsSelected() ? Container(
                          padding: EdgeInsets.only(left: 64, right: 64),
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            textAlign: TextAlign.center,
                            text: 'Selected options will be presented to your client when they select "Pay Now" in the client portal.',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ) : SizedBox(),
                        Container(
                          margin: EdgeInsets.only(top: 32, bottom: 8),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            textAlign: TextAlign.center,
                            text: 'Message to Client',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        Container(
                          height: 232,
                          margin: EdgeInsets.only(left: 16, right: 16),
                          padding: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(24)
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: ShareWithClientTextField(
                              messageController,
                              '',
                              TextInputType.multiline,
                              200.0,
                              pageState.onMessageChanged,
                              'noError',
                              TextInputAction.newline,
                              _messageFocusNode,
                              onAction,
                              TextCapitalization.sentences,
                              null,
                              true,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 32, bottom: 8),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            textAlign: TextAlign.center,
                            text: 'Select Items to Share',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        Container(
                          height: 232,
                          margin: EdgeInsets.only(left: 16, right: 16, bottom: 264),
                          padding: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(24)
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                alignment: Alignment.center,
                                height: 48.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: CheckboxListTile(
                                  title: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Job Details',
                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                  ),
                                  tileColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                  value: true,
                                  activeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                                  onChanged: (selected) {

                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                alignment: Alignment.center,
                                height: 48.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: CheckboxListTile(
                                  title: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Contract',
                                  ),
                                  value: pageState.contractSelected,
                                  activeColor: Color(ColorConstants.getPeachDark()),
                                  onChanged: (selected) {
                                    pageState.onContractCheckBoxSelected(selected);
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                alignment: Alignment.center,
                                height: 48.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: CheckboxListTile(
                                  title: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Invoice',
                                  ),
                                  value: pageState.invoiceSelected,
                                  activeColor: Color(ColorConstants.getPeachDark()),
                                  onChanged: (selected) {
                                    pageState.onInvoiceCheckBoxSelected(selected);
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                alignment: Alignment.center,
                                height: 48.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: CheckboxListTile(
                                  title: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Poses',
                                  ),
                                  value: pageState.posesSelected,
                                  activeColor: Color(ColorConstants.getPeachDark()),
                                  onChanged: (selected) {
                                    pageState.onPosesCheckBoxSelected(selected);
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 96),
                child: GestureDetector(
                  onTap: () {
                    _launchBrandingPreviewURL(profile.uid, job.documentId);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 32, right: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getPeachDark()),
                      boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'View as client',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 32),
                child: GestureDetector(
                  onTap: () {
                    String shareMessage = 'Select the link below to view your job details.';
                    if(pageState.contractSelected && pageState.invoiceSelected && pageState.posesSelected) {
                      shareMessage = 'Select the link below to view your job details, sign the contract, view/pay the invoice and view poses for inspiration.';
                    }
                    if(pageState.contractSelected && pageState.invoiceSelected) {
                      shareMessage = 'Select the link below to view your job details, sign the contract and view/pay the invoice.';
                    }
                    if(pageState.contractSelected && pageState.posesSelected) {
                      shareMessage = 'Select the link below to view your job details, sign the contract and view poses for inspiration.';
                    }
                    if(pageState.invoiceSelected && pageState.posesSelected) {
                      shareMessage = 'Select the link below to view your job details, view/pay the invoice and view poses for inspiration.';
                    }
                    if(pageState.invoiceSelected) {
                      shareMessage = 'Select the link below to view your job details and view/pay the invoice.';
                    }
                    if(pageState.contractSelected) {
                      shareMessage = 'Select the link below to view your job details and sign the contract.';
                    }
                    if(pageState.posesSelected) {
                      shareMessage = 'Select the link below to view your job details and view poses for inspiration.';
                    }
                    Share.share(shareMessage + '\n\nhttps://dandylight.com/clientPortal/${profile.uid}+${job.documentId}');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 32, right: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getPeachDark()),
                      boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Share',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }

  void _launchBrandingPreviewURL(String uid, String jobId) async => await canLaunchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.CLIENT_PORTAL + '/' + uid + '+' + jobId)) ? await launchUrl(Uri.parse('https://clientsafe-21962.web.app/' + RouteNames.CLIENT_PORTAL + '/' + uid + '+' + jobId), mode: LaunchMode.platformDefault) : throw 'Could not launch';

}
