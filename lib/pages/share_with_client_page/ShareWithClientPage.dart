
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientActions.dart';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/ShareOptionsBottomSheet.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Client.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../navigation/routes/RouteNames.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';
import 'ShareWithClientSetupBottomSheet.dart';
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
  OverlayEntry overlayEntry;
  bool isKeyboardVisible = false;
  bool initialSetupState = false;
  _isThisPageShowing(BuildContext context) => pageContext != null && ModalRoute.of(pageContext)?.isCurrent == true;
  BuildContext pageContext = null;

  _ShareWithClientPageState(this.job);

  void handleClick(String value) {
    switch (value) {
      case 'Branding':
        NavigationUtil.onEditBrandingSelected(context);
        EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_SHARE);
        break;
      case 'Business Info':
        NavigationUtil.onEditProfileSelected(context, profile);
        EventSender().sendEvent(eventName: EventNames.SETUP_BUSINESS_INFO_FROM_SHARE);
        break;
      case 'Payment Options':
        NavigationUtil.onPaymentRequestInfoSelected(context);
        EventSender().sendEvent(eventName: EventNames.SETUP_PAYMENT_OPTIONS_FROM_SHARE);
        break;
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void _showSetupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return ShareWithClientSetupBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, ShareWithClientPageState>(
        onInit: (store) async {
          profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
          pageContext = context;
          await store.dispatch(FetchProfileAction(store.state.shareWithClientPageState));
          store.dispatch(SetJobShareWithClientAction(store.state.shareWithClientPageState, job));
          String clientName = job.client != null ? job.client.firstName : 'Client';
          String clientMessage = "(Example message in client portal)\n\nHi ${clientName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${profile.firstName} ${profile.lastName ?? ''}\n${profile.businessName ?? ''}";
          messageController.value = messageController.value.copyWith(text: job.proposal.detailsMessage != null && job.proposal.detailsMessage.isNotEmpty ? job.proposal.detailsMessage : clientMessage);
          if(job.proposal.detailsMessage.isEmpty) {
            store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, clientMessage));
          }

          KeyboardVisibilityNotification().addNewListener(
              onShow: () {
                showOverlay(context);
                setState(() {
                  isKeyboardVisible = true;
                });
              },
              onHide: () {
                removeOverlay();
                setState(() {
                  isKeyboardVisible = false;
                });
              }
          );
          setState(() {
            initialSetupState = !profile.isProfileComplete() || !profile.hasSetupBrand || !profile.paymentOptionsSelected();
          });
          EventSender().setUserProfileData(EventNames.IS_PORTAL_SETUP_COMPLETE, !initialSetupState);
        },
        onWillChange: (previous, current) {
          setState(() {
            profile = current.profile;
          });
        },
        onDidChange: (previous, current) {
          if(initialSetupState) {
            setState(() {
              initialSetupState = false;
            });
            _showSetupSheet(context);
          } else {
            if(previous.profile != null && current.profile != null) {
              bool shouldShowCurrent = !current.profile.isProfileComplete() || !current.profile.hasSetupBrand || !current.profile.paymentOptionsSelected();
              bool shouldShowPrevious = !previous.profile.isProfileComplete() || !previous.profile.hasSetupBrand || !previous.profile.paymentOptionsSelected();
              if(shouldShowCurrent && !shouldShowPrevious) {
                if(_isThisPageShowing(context)) {
                  _showSetupSheet(context);
                }
              }
            }
          }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  !isKeyboardVisible ? Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                        pageState.saveProposal();
                        if(pageState.profile.isProfileComplete() && pageState.profile.hasSetupBrand && pageState.profile.paymentOptionsSelected()) {
                          IntentLauncherUtil.launchBrandingPreviewURL(UidUtil().getUid(), job.documentId);
                          EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_PREVIEW_SELECTED);
                        } else {
                          String toastMessage = '';
                          if(!pageState.profile.isProfileComplete()) {
                            toastMessage = 'Please complete your profile first.';
                          } else if(!pageState.profile.hasSetupBrand) {
                            toastMessage = 'Please setup your brand first.';
                          }
                          DandyToastUtil.showErrorToast(toastMessage);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.only(left: 32, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(ColorConstants.getPeachDark()),
                          boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Preview',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  !isKeyboardVisible ? Container(
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                          String message = '[Your message goes here]\n\nAccess your client portal here:' + '\nhttps://dandylight.com/clientPortal/${profile.uid}+${job.documentId} \n\nPowered by DandyLight';
                          String emailTitle = pageState.profile.businessName != null && pageState.profile.businessName.isNotEmpty ? pageState.profile.businessName + ' - Session details' : pageState.profile.firstName != null && pageState.profile.firstName.isNotEmpty ? pageState.profile.firstName + ' - Session details' : 'Session details';
                          UserOptionsUtil.showShareOptionsSheet(context, pageState.job.client, message,  emailTitle);
                          EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED, properties: {
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_INVOICE : pageState.invoiceSelected,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_CONTRACT : pageState.contractSelected,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_POSES : pageState.posesSelected,
                            EventNames.SHARE_WITH_CLIENT_SHARE_SELECTED_PARAM_LINK : 'https://dandylight.com/clientPortal/${profile.uid}+${job.documentId}',
                          });
                          pageState.saveProposal();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width/2,
                        margin: EdgeInsets.only(left: 8, right: 32),
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
                  ) : SizedBox()
                ],
              ),
            ],
          ),
        ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }
}
