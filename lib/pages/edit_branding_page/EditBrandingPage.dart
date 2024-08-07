import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/Profile.dart';
import '../../navigation/routes/RouteNames.dart';
import '../../utils/Shadows.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'BannerSelectionWidget.dart';
import 'ColorThemeSelectionWidget.dart';
import 'EditBrandingPageActions.dart';
import 'EditBrandingPageState.dart';
import 'FontThemeSelectionWidget.dart';
import 'LogoSelectionWidget.dart';

class EditBrandingPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _EditBrandingPageState();
  }
}

class _EditBrandingPageState extends State<EditBrandingPage> with TickerProviderStateMixin {
  _isProgressDialogShowing(BuildContext context) => progressContext != null && ModalRoute.of(progressContext!)?.isCurrent == true;
  BuildContext? progressContext;


  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, EditBrandingPageState>(
        onInit: (store) {
          store.dispatch(ClearBrandingPreviewStateAction(store.state.editBrandingPageState));
        },
        onDidChange: (previous, current) {
          if(previous!.uploadInProgress! && !current!.uploadInProgress! && _isProgressDialogShowing(context)) {
            Navigator.of(context).pop();
            _launchBrandingPreviewURL(UidUtil().getUid());
          }
        },
        converter: (Store<AppState> store) => EditBrandingPageState.fromStore(store),
        builder: (BuildContext context, EditBrandingPageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              // show the confirm dialog
              if(pageState.showPublishButton!) {
                await showDialog(
                    context: context,
                    builder: (_) => Device.get().isIos ?
                    CupertinoAlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be published.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                      ],
                    ) : AlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be published.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                      ],
                    ));
              } else {
                willLeave = true;
              }
              return willLeave;
            },
            child: Scaffold(
              backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                            surfaceTintColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                            iconTheme: IconThemeData(
                              color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                            ),
                            backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                            pinned: true,
                            centerTitle: true,
                            elevation: 2.0,
                            title: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: "Branding",
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                        ),
                        SliverPadding(
                          padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      LogoSelectionWidget(),
                                      ColorThemeSelectionWidget(),
                                      FontThemeSelectionWidget(),
                                      BannerSelectionWidget(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 96),
                    child: GestureDetector(
                      onTap: () {
                        if(pageState.showPublishButton!) {
                          pageState.onPublishChangesSelected!();
                          showSuccessAnimation();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 32, right: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: pageState.showPublishButton! ? Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getPrimaryGreyMedium()),
                          boxShadow: ElevationToShadow[4],
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Publish Changes',
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
                    padding: const EdgeInsets.only(bottom: 32),
                    child: GestureDetector(
                      onTap: () {
                        if(!pageState.uploadInProgress!) {
                          _launchBrandingPreviewURL(UidUtil().getUid());
                          EventSender().sendEvent(eventName: EventNames.BRANDING_PREVIEW_SELECTED);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              setState(() {
                                progressContext = context;
                              });
                              return AlertDialog(
                                title: TextDandyLight(
                                  textAlign: TextAlign.center,
                                  text: 'Pleas wait a moment\nwhile we prepare your preview...',
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                titlePadding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                                contentPadding: const EdgeInsets.all(0),
                                content: Container(
                                  height: 96,
                                  width: 250,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: LoadingAnimationWidget.fourRotatingDots(
                                    color: Color(ColorConstants.getPeachDark()),
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 32, right: 32),
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
                  ),
                ],
              ),
            ),
        ),
      );

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    // Navigator.of(context).pop(true);
  }

  void _launchBrandingPreviewURL(String uid) async {
    print('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid);
    await canLaunchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid)) ? await launchUrl(Uri.parse('https://dandylight.com/' + RouteNames.BRANDING_PREVIEW + '/' + uid), mode: LaunchMode.externalApplication) : throw 'Could not launch';
  }
}
