import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

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
                      title: Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                    ),
                    SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          SafeArea(
                            child: Container(
                              margin: EdgeInsets.only(left: 16.0, right: 16.0),
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
                                                margin: EdgeInsets.only(right: 16.0),
                                                height: 28.0,
                                                width: 28.0,
                                                child: Image.asset('assets/images/icons/profile_icon_black.png'),
                                              ),
                                              Text(
                                                'Edit profile',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontFamily: 'simple',
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                  Color(ColorConstants.getPrimaryBlack()),
                                                ),
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
                                  Share.share('Hey you should try this app, i love it!'
                                      '\n\nDandyLight: Photography Business Management'
                                      '\n\nUse this referral code when signing up so your friend can get 3 months free.'
                                      '\n\nCode: ' + pageState.profile.referralUid +
                                      '\n\nDandyLight.com');
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
                                            child: Image.asset('assets/images/icons/file_upload.png', color: Color(ColorConstants.getPrimaryBlack()),),
                                          ),
                                          Text(
                                            'Share DandyLight',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
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
                                          Text(
                                            'Manage Subscription',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
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
                                onPressed: () {},
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
                                                'assets/images/icons/provide_feedback_icon_black.png'),
                                          ),
                                          Text(
                                            'Provide feedback',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
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
                                onPressed: () {},
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
                                          Text(
                                            'Suggestions',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants
                                                  .getPrimaryBlack()),
                                            ),
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
                                      Text(
                                        'Push Notifications',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.getPrimaryBlack()),
                                        ),
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
                                        activeTrackColor: Color(ColorConstants.getBlueDark()),
                                        inactiveTrackColor: Color(ColorConstants.getBlueLight()),
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
                                  child: Text(
                                    'Enable push notifications to get notified of job reminders, expenses, invoices and contracts.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 48.0,
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Calendar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.getPrimaryBlack()),
                                        ),
                                      ),
                                      Device.get().isIos?
                                      CupertinoSwitch(
                                        trackColor: Color(ColorConstants.getBlueLight()),
                                        activeColor: Color(ColorConstants.getBlueDark()),
                                        onChanged: (enabled) {
                                          pageState.onCalendarChanged(enabled);
                                        },
                                        value: pageState.calendarEnabled,
                                      ) : Switch(
                                        activeTrackColor: Color(ColorConstants.getBlueDark()),
                                        inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                                        onChanged: (enabled) {
                                          pageState.onCalendarChanged(enabled);
                                        },
                                        value: pageState.calendarEnabled,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                                  child: Text(
                                    'Enable DandyLight to sync your jobs with your personal device calendars.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
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
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 28.0,
                                              width: 28.0,
                                              child: Image.asset('assets/images/icons/question_mark.png'),
                                            ),
                                            Text(
                                              'FAQ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color:
                                                Color(ColorConstants.getPrimaryBlack()),
                                              ),
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
                                  onPressed: () {},
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
                                            Text(
                                              'Terms & Privacy',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color: Color(ColorConstants
                                                    .getPrimaryBlack()),
                                              ),
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
                              child: Text(
                                'Sign out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
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
}
