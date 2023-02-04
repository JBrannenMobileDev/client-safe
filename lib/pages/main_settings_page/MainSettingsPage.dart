import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/pages/main_settings_page/DeleteAccountPage.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/TextDandyLight.dart';
import 'SuggestionsPage.dart';

class MainSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainSettingsPageState();
  }
}

class _MainSettingsPageState extends State<MainSettingsPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(LoadSettingsFromProfile(store.state.mainSettingsPageState));
        },
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) =>
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                      ),
                      brightness: Brightness.light,
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Settings",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0, top: 16),
                              padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      NavigationUtil.onEditProfileSelected(context, pageState.profile);
                                    },
                                    child: SizedBox(
                                      height: 48.0,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(right: 18.0, left: 2.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset('assets/images/icons/profile_icon_black.png'),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Edit profile',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              )
                                            ],
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.chevron_right,
                                              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(),
                                onPressed: () {
                                  Share.share('Hey checkout this app.'
                                      '\n\nDandyLight - Photography Business Management'
                                      // '\n\nUse this referral code when signing up so your friend can get 3 months free.'
                                      // '\n\nCode: ' + pageState.profile.referralUid +
                                      '\n\nhttps://linktr.ee/dandylight');
                                },
                                child: SizedBox(
                                  height: 48.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(right: 18.0, left: 2.0),
                                            height: 28.0,
                                            width: 28.0,
                                            child: Image.asset('assets/images/icons/file_upload.png', color: Color(ColorConstants.getPrimaryBlack()),),
                                          ),
                                          TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Share DandyLight',
                                            textAlign: TextAlign.center,
                                            color: Color(ColorConstants
                                                .getPrimaryBlack()),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(),
                                onPressed: () {
                                  NavigationUtil.onManageSubscriptionSelected(context, pageState.profile);
                                },
                                child: SizedBox(
                                  height: 48.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.only(right: 16.0),
                                            height: 32.0,
                                            width: 32.0,
                                            child: Image.asset(
                                                'assets/images/icons/manage_subscription_icon_black.png'),
                                          ),
                                          TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Manage Subscription',
                                            textAlign: TextAlign.center,
                                            color: Color(ColorConstants
                                                .getPrimaryBlack()),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context) => SuggestionsPage()),
                                  );
                                },
                                child: SizedBox(
                                  height: 48.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin:
                                            EdgeInsets.only(right: 16.0),
                                            height: 32.0,
                                            width: 32.0,
                                            child: Image.asset(
                                                'assets/images/icons/suggestions_icon_black.png'),
                                          ),
                                          TextDandyLight(
                                            type: TextDandyLight.MEDIUM_TEXT,
                                            text: 'Suggestions',
                                            textAlign: TextAlign.center,
                                            color: Color(ColorConstants
                                                .getPrimaryBlack()),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Color(ColorConstants
                                              .getPrimaryBackgroundGrey()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      _sendIssueReportEmail(pageState);
                                    },
                                    child: SizedBox(
                                      height: 48.0,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 16.0),
                                                height: 32.0,
                                                width: 32.0,
                                                child: Image.asset(
                                                    'assets/images/icons/alert_icon_circle.png', color: Color(ColorConstants.getPrimaryBlack()),),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Report an Issue',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants
                                                    .getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.chevron_right,
                                              color: Color(ColorConstants
                                                  .getPrimaryBackgroundGrey()),
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
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 48.0,
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Push Notifications',
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      Device.get().isIos?
                                      CupertinoSwitch(
                                        trackColor: Color(ColorConstants.getBlueLight()),
                                        activeColor: Color(ColorConstants.getBlueDark()),
                                        onChanged: (enabled) {
                                          pageState.onPushNotificationsChanged(enabled);
                                        },
                                        value: pageState.pushNotificationsEnabled,
                                      ) : Switch(
                                        activeTrackColor: Color(ColorConstants.getBlueLight()),
                                        inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                        activeColor: Color(ColorConstants.getBlueDark()),
                                        onChanged: (enabled) {
                                          pageState.onPushNotificationsChanged(enabled);
                                        },
                                        value: pageState.pushNotificationsEnabled,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Enable push notifications to get notified of job reminders, expenses, invoices and contracts.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 48.0,
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Calendar',
                                        textAlign: TextAlign.center,
                                        color: Color(ColorConstants.getPrimaryBlack()),
                                      ),
                                      Device.get().isIos?
                                      CupertinoSwitch(
                                        trackColor: Color(ColorConstants.getBlueLight()),
                                        activeColor: Color(ColorConstants.getBlueDark()),
                                        onChanged: (enabled) {
                                          if(enabled) {
                                            UserOptionsUtil.showCalendarSelectionDialog(context, pageState.onCalendarChanged);
                                          } else {
                                            pageState.onCalendarChanged(enabled);
                                          }
                                        },
                                        value: pageState.calendarEnabled,
                                      ) : Switch(
                                        activeTrackColor: Color(ColorConstants.getBlueLight()),
                                        inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                        activeColor: Color(ColorConstants.getBlueDark()),
                                        onChanged: (enabled) {
                                          if(enabled) {
                                            UserOptionsUtil.showCalendarSelectionDialog(context, pageState.onCalendarChanged);
                                          } else {
                                            pageState.onCalendarChanged(enabled);
                                          }
                                        },
                                        value: pageState.calendarEnabled,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    text: 'Enable DandyLight to sync your jobs with your personal device calendars.',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    _launchPrivacyPolicyURL();
                                  },
                                  child: SizedBox(
                                    height: 48.0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/icons/signature.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.MEDIUM_TEXT,
                                              text: 'Privacy Policy',
                                              textAlign: TextAlign.center,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Platform.isIOS ?  TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    _launchAppleEULA();
                                  },
                                  child: SizedBox(
                                    height: 48.0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/icons/signature.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.MEDIUM_TEXT,
                                              text:'Terms of Use',
                                              textAlign: TextAlign.center,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ) : TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    _launchTermsOfServiceURL();
                                  },
                                  child: SizedBox(
                                    height: 48.0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/icons/signature.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.MEDIUM_TEXT,
                                              text:'Terms and Conditions',
                                              textAlign: TextAlign.center,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: Styles.getButtonStyle(),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                                    );
                                  },
                                  child: SizedBox(
                                    height: 48.0,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/icons/trash_icon_white.png', color: Color(ColorConstants.getPrimaryBlack(),)),
                                            ),
                                            TextDandyLight(
                                              type: TextDandyLight.MEDIUM_TEXT,
                                              text: 'Delete Account',
                                              textAlign: TextAlign.center,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              pageState.onSignOutSelected();
                              FirebaseAuthentication().signOut();
                              NavigationUtil.onSignOutSelected(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 48.0,
                              width: 172.0,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPeachDark()),
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Sign out',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 128.0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
  void _sendIssueReportEmail(MainSettingsPageState pageState) async => await IntentLauncherUtil.sendEmail('support@dandylight.com', "Reporting an issue", 'User Info: \nid = ' + pageState.profile.uid + '\naccount email = ' + pageState.profile.email + '\nfirst name = ' + pageState.profile.firstName + '\n\nIssue description: \n[Your message here - Attaching a screenshot of the issue will help us resolve the issue even faster.]');
  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
  void _launchAppleEULA() async => await canLaunchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) ? await launchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) : throw 'Could not launch';

}
