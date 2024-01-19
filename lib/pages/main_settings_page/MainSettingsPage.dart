import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/pages/main_settings_page/DeleteAccountPage.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/DandyToastUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'GenerateDiscountCodeBottomSheet.dart';

class MainSettingsPage extends StatefulWidget {
  const MainSettingsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainSettingsPageState();
  }
}

class _MainSettingsPageState extends State<MainSettingsPage> with TickerProviderStateMixin, WidgetsBindingObserver {
  MainSettingsPageState localState;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      PermissionStatus status = await UserPermissionsUtil.getPermissionStatus(Permission.notification);
      if(status.isGranted) localState.onPushNotificationsChanged(true);
    }
  }

  void callOnGranted() {

  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(LoadSettingsFromProfile(store.state.mainSettingsPageState));
        },
        onInitialBuild: (current) async {
            localState = current;
        },
        onDidChange: (previous, current) {
          if(previous.discountCode != current.discountCode) {
            Clipboard.setData(ClipboardData(text: current.discountCode));
            DandyToastUtil.showToast('${current.discountCode} Copied to Clipboard!', const Color(ColorConstants.error_red));
          }
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
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      pinned: true,
                      centerTitle: true,
                      elevation: 0.0,
                      title: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Settings",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ), systemOverlayStyle: SystemUiOverlayStyle.dark,
                    ),
                    SliverPadding(
                      padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0, top: 16),
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(12.0),
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
                                                margin: const EdgeInsets.only(right: 18.0, left: 2.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset('assets/images/icons/profile_icon_black.png'),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Profile',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      NavigationUtil.onEditBrandingSelected(context);
                                      EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_SETTINGS);
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
                                                margin: const EdgeInsets.only(right: 18.0, left: 2.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset('assets/images/icons/art.png'),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Branding',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
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
                                                margin: const EdgeInsets.only(right: 18.0, left: 2.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
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
                                                const EdgeInsets.only(right: 16.0),
                                                height: 32.0,
                                                width: 32.0,
                                                child: Image.asset(
                                                  'assets/images/icons/subscription.png', color: Color(ColorConstants.getPrimaryBlack()),),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      _sendSuggestionEmail(pageState);
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
                                                const EdgeInsets.only(right: 16.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
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
                                                const EdgeInsets.only(right: 16.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 48.0,
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                                          thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                          onChanged: (enabled) async {
                                            bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.notification, context: context);
                                            if(isGranted) pageState.onPushNotificationsChanged(enabled);
                                          },
                                          value: pageState.pushNotificationsEnabled,
                                        ) : Switch(
                                          activeTrackColor: Color(ColorConstants.getBlueLight()),
                                          inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                          activeColor: Color(ColorConstants.getBlueDark()),
                                          onChanged: (enabled) async {
                                            bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.notification, context: context);
                                            if(isGranted) pageState.onPushNotificationsChanged(enabled);
                                          },
                                          value: pageState.pushNotificationsEnabled,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
                                    child: TextDandyLight(
                                      type: TextDandyLight.SMALL_TEXT,
                                      text: 'Enable push notifications to get notified of job reminders, expenses, invoices and contracts.',
                                      textAlign: TextAlign.start,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Container(
                                    height: 48.0,
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                                          thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                          onChanged: (enabled) async {
                                            bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.calendar, context: context);
                                            if(isGranted) {
                                              if(enabled) {
                                                UserOptionsUtil.showCalendarSelectionDialog(context, pageState.onCalendarChanged);
                                              } else {
                                                pageState.onCalendarChanged(enabled);
                                              }
                                            }
                                          },
                                          value: pageState.calendarEnabled,
                                        ) : Switch(
                                          activeTrackColor: Color(ColorConstants.getBlueLight()),
                                          inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                          activeColor: Color(ColorConstants.getBlueDark()),
                                          onChanged: (enabled) async {
                                            bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.calendar, context: context);
                                            if(isGranted) {
                                              if(enabled) {
                                                UserOptionsUtil.showCalendarSelectionDialog(context, pageState.onCalendarChanged);
                                              } else {
                                                pageState.onCalendarChanged(enabled);
                                              }
                                            }
                                          },
                                          value: pageState.calendarEnabled,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
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
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(12.0),
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
                                                margin: const EdgeInsets.only(right: 16.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
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
                                                margin: const EdgeInsets.only(right: 16.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
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
                                                margin: const EdgeInsets.only(right: 16.0),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => DeleteAccountPage()),
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset('assets/images/icons/trash_can.png', color: Color(ColorConstants.getPrimaryBlack(),)),
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
                                          Icon(
                                            Icons.chevron_right,
                                            color: Color(ColorConstants
                                                .getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            pageState.isAdmin ? Container(
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 32.0),
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 48.0,
                                    child: TextDandyLight(
                                      type: TextDandyLight.LARGE_TEXT,
                                      text: 'Admin Tools',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants
                                          .getPrimaryBlack()),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      _showGenerateDiscountCodeBottomSheet(context, DiscountCodes.FIFTY_PERCENT_TYPE);
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Icon(
                                                  Icons.discount,
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Generate 50% Discount Code',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      _showGenerateDiscountCodeBottomSheet(context, DiscountCodes.LIFETIME_FREE);
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Icon(
                                                  Icons.discount,
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Generate Free Discount Code',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.add,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: pageState.discountCode));
                                      DandyToastUtil.showToast('${pageState.discountCode} Copied to Clipboard!', const Color(ColorConstants.error_red));
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Icon(
                                                  Icons.visibility,
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Show Last Generated Code',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.visibility,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: Styles.getButtonStyle(),
                                    onPressed: () {
                                      pageState.populateAccountWithData();
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
                                                margin: const EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Icon(
                                                  Icons.document_scanner_outlined,
                                                  color: Color(ColorConstants.getPrimaryBlack()),
                                                ),
                                              ),
                                              TextDandyLight(
                                                type: TextDandyLight.MEDIUM_TEXT,
                                                text: 'Populate account with data',
                                                textAlign: TextAlign.center,
                                                color: Color(ColorConstants.getPrimaryBlack()),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.document_scanner_outlined,
                                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ) : const SizedBox(),
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
                            const SizedBox(
                              height: 128.0,
                            )
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
      );

  void _showGenerateDiscountCodeBottomSheet(BuildContext context, String discountType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return GenerateDiscountCodeBottomSheet(discountType);
      },
    );
  }

  void _sendSuggestionEmail(MainSettingsPageState pageState) async => await IntentLauncherUtil.sendEmail('support@dandylight.com', "Suggestion", 'User Info: \nid = ${pageState.profile.uid}\naccount email = ${pageState.profile.email}\nfirst name = ${pageState.profile.firstName}\n\nSuggestion: \n[Please enter your suggestion here.]');
  void _sendIssueReportEmail(MainSettingsPageState pageState) async => await IntentLauncherUtil.sendEmail('support@dandylight.com', "Reporting an issue", 'User Info: \nid = ${pageState.profile.uid}\naccount email = ${pageState.profile.email}\nfirst name = ${pageState.profile.firstName}\n\nIssue description: \n[Your message here - Attaching a screenshot of the issue will help us resolve the issue even faster.]');
  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
  void _launchAppleEULA() async => await canLaunchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) ? await launchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) : throw 'Could not launch';

}
