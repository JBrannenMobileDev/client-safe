import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/GoToJobPosesBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ActiveJobsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobTypeBreakdownPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobsThisWeekHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LeadSourcesPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/RestorePurchasesBottomSheet.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StageStatsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/MonthlyProfitLineChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StartAJobButton.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPage.dart';
import 'package:dandylight/utils/AdminCheckUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../utils/NotificationHelper.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key key, this.destination, this.comingFromLogin}) : super(key: key);
  final DashboardPage destination;
  final bool comingFromLogin;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, key) {
        // log('onStart: $index, $key');
      },
      onComplete: (index, key) {
        // log('onComplete: $index, $key');
      },
      blurValue: 2,
      builder: Builder(builder: (context) => HolderPage(comingFromLogin: comingFromLogin)),
    );
  }
}

class HolderPage extends StatefulWidget {
  final bool comingFromLogin;
  const HolderPage({Key key, this.comingFromLogin}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState(comingFromLogin);
}

class _DashboardPageState extends State<HolderPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  ScrollController _scrollController;
  bool dialVisible = true;
  bool isFabExpanded = false;
  bool comingFromLogin;
  bool goToHasBeenSeen = false;

  _DashboardPageState(this.comingFromLogin);

  AnimationController controller;
  AnimationController _animationController;

  Tween<Offset> offsetUpTween;
  Tween<Offset> offsetDownTween;

  void _startShowcase() {
    ShowCaseWidget.of(context).startShowCase([_one, _two, _three]);
  }

  initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    offsetUpTween = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );
    offsetDownTween = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );
    if (comingFromLogin) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this);
      controller.forward();
    } else {
      controller = AnimationController(
          duration: const Duration(milliseconds: 0), vsync: this);
      controller.forward();
    }
  }

  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Animation<Offset> get offsetAnimationUp => offsetUpTween.animate(
        new CurvedAnimation(
          parent: controller,
          curve: new Interval(
            0.0,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  Animation<Offset> get offsetAnimationDown => offsetDownTween.animate(
        new CurvedAnimation(
          parent: controller,
          curve: new Interval(
            0.0,
            1.0,
            curve: Curves.ease,
          ),
        ),
      );

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) async {
    print('notification(${notificationResponse.id}) action tapped: ''${notificationResponse.actionId} with'' payload: ${notificationResponse.payload}');

    // if((notificationResponse.payload?.isNotEmpty ?? false) && notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
    //   Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    //   profile.showNewMileageExpensePage = true;
    //   ProfileDao.update(profile);
    // }
  }

  void _showRestorePurchasesSheet(BuildContext context, String restoreMessage) {
    EventSender().sendEvent(eventName: EventNames.BT_RESTORE_PURCHASES_SHEET);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return RestorePurchasesBottomSheet(restoreMessage);
      },
    );
  }

  void _showGoToJobPosesSheet(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return GoToJobPosesBottomSheet(job);
      },
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
        onInit: (store) async {
          store.dispatch(new InitDashboardPageAction(store.state.dashboardPageState));
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState));
          store.dispatch(CheckForGoToJobAction(store.state.dashboardPageState));
          if(store.state.dashboardPageState.unseenNotificationCount > 0) {
            _runAnimation();
          }
          List<Job> allJobs = await JobDao.getAllJobs();
          List<JobReminder> allReminders = await JobReminderDao.getAll();
          final notificationHelper = NotificationHelper();
          notificationHelper.setTapBackgroundMethod(notificationTapBackground);

          //If permanently denied we do not want to bug the user every time they log in.  We will prompt every time they start a job instead. Also they can change the permission from the app settings.

          bool isGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.notification)).isGranted;
          if(isGranted) {
            await notificationHelper.initNotifications();
            if(allJobs.length > 1 || allJobs.elementAt(0).clientName != "Example Client") {
              if(allReminders.length > 0) {
                NotificationHelper().createAndUpdatePendingNotifications();
              }
            }
          }

          if(store.state.dashboardPageState.profile != null && store.state.dashboardPageState.profile.shouldShowRestoreSubscription) {
            String restoreMessage = null;

            if(store.state.dashboardPageState.subscriptionState!= null) {
              if(store.state.dashboardPageState.subscriptionState.entitlements.all['standard'] != null) {
                if(store.state.dashboardPageState.subscriptionState.entitlements.all['standard'].isActive) {
                  restoreMessage = ManageSubscriptionPage.SUBSCRIBED;
                  store.state.dashboardPageState.profile.isSubscribed = true;
                  ProfileDao.update(store.state.dashboardPageState.profile);
                  EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIBED);
                } else {
                  store.state.dashboardPageState.profile.isSubscribed = false;
                  ProfileDao.update(store.state.dashboardPageState.profile);
                  EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIPTION_EXPIRED);
                  //Subscription expired - do nothing
                }
              } else {
                store.state.dashboardPageState.profile.isSubscribed = false;
                ProfileDao.update(store.state.dashboardPageState.profile);
                restoreMessage = ManageSubscriptionPage.FREE_TRIAL;
                EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.FREE_TRIAL);
              }
            }

            if(restoreMessage != null) {
              Future.delayed(Duration(seconds: 1), () {
                _showRestorePurchasesSheet(context, restoreMessage);
                store.dispatch(UpdateProfileRestorePurchasesSeen(store.state.dashboardPageState));
              });
            }
          }

          bool isCalendarGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.calendar)).isGranted;
          if(isCalendarGranted && store.state.dashboardPageState.profile != null && !store.state.dashboardPageState.profile.calendarEnabled) {
            Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
            profile.calendarEnabled = true;
            ProfileDao.update(profile);
          }
        },
        onDidChange: (previous, current) async {
          if(!goToHasBeenSeen && !current.goToSeen && current.goToPosesJob != null){
            _showGoToJobPosesSheet(context, current.goToPosesJob);
            setState(() {
              goToHasBeenSeen = true;
            });
            current.onGoToSeen();
          }
          if(!previous.shouldShowNewMileageExpensePage && current.shouldShowNewMileageExpensePage) {
            UserOptionsUtil.showNewMileageExpenseSelected(context);
          }
          if(!current.hasSeenShowcase) {
            _startShowcase();
            current.onShowcaseSeen();
          }
        },

        converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) {
          return Scaffold(
            backgroundColor: Color(ColorConstants.getBlueLight()),
            floatingActionButton: Showcase(
              key: _one,
              targetPadding: EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
              targetShapeBorder: CircleBorder(),
              description: 'Start a new job or \nadd a new contact here!',
              descTextStyle: TextStyle(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                fontFamily: TextDandyLight.getFontFamily(),
                fontWeight: TextDandyLight.getFontWeight(),
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
              child:

              SpeedDial(
                childMargin: EdgeInsets.only(right: 18.0, bottom: 20.0),
                child: getFabIcon(),
                visible: dialVisible,
                // If true user is forced to close dial manually
                // by tapping main button and overlay is not rendered.
                closeManually: false,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                tooltip: 'Speed Dial',
                heroTag: 'speed-dial-hero-tag',
                backgroundColor: Color(ColorConstants.getBlueDark()),
                foregroundColor: Colors.black,
                elevation: 8.0,
                shape: CircleBorder(),
                onOpen: () {
                  setState(() {
                    isFabExpanded = true;
                  });
                },
                onClose: () {
                  setState(() {
                    isFabExpanded = false;
                  });
                },
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.business_center),
                    backgroundColor: Color(ColorConstants.getBlueLight()),
                    labelWidget: Container(
                      alignment: Alignment.center,
                      height: 42.0,
                      width: 156.0,
                      decoration: BoxDecoration(
                        boxShadow: ElevationToShadow[4],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21.0),
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Start new job',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    onTap: () {
                      UserOptionsUtil.showNewJobDialog(context, false);
                      EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Dashboard"});
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.person_add),
                    backgroundColor: Color(ColorConstants.getPeachDark()),
                    labelWidget: Container(
                      alignment: Alignment.center,
                      height: 42.0,
                      width: 138.0,
                      decoration: BoxDecoration(
                        boxShadow: ElevationToShadow[4],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21.0),
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'New contact',
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    onTap: () {
                      UserOptionsUtil.showNewContactDialog(context, false);
                      EventSender().sendEvent(eventName: EventNames.BT_ADD_NEW_CONTACT, properties: {EventNames.CONTACT_PARAM_COMING_FROM : "Dashboard Page"});
                    },
                  ),
                ],
              ),
            ),
            body: Container(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Showcase(
                      key: _three,
                      targetPadding: EdgeInsets.only(right: -8, left: 8, bottom: 55, top: -55),
                      targetShapeBorder: CircleBorder(),
                      description: 'Get started here!  \nThis is your collections page where \nyou can setup the details for your business',
                      descTextStyle: TextStyle(
                        fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                        fontFamily: TextDandyLight.getFontFamily(),
                        fontWeight: TextDandyLight.getFontWeight(),
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      child:SizedBox(
                        height: 64,
                        width: 64,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueLight()),
                    ),
                  ),
                  CustomScrollView(
                    physics: new ClampingScrollPhysics(),
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        pinned: false,
                        floating: false,
                        forceElevated: false,
                        expandedHeight: 175.0,
                        title: pageState.profile != null && !pageState.profile.isSubscribed && !pageState.profile.isFreeForLife ? GestureDetector(
                          onTap: () {
                            NavigationUtil.onManageSubscriptionSelected(context, pageState.profile);
                            EventSender().sendEvent(eventName: EventNames.BT_SUBSCRIBE_NOW);
                          },
                          child: Container(
                            width: 132,
                            alignment: Alignment.center,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(ColorConstants.getPeachDark()),
                              boxShadow: ElevationToShadow[2],
                            ),
                            child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                color: Color(ColorConstants.getPrimaryWhite()),
                                text: "Subscribe"
                            ),
                          ),
                        ) : SizedBox(),
                        leading: Showcase(
                          key: _two,
                          targetPadding: EdgeInsets.only(right: 13, bottom: 7, top: 6),
                          targetShapeBorder: CircleBorder(),
                          description: 'Sunset & Weather',
                          descTextStyle: TextStyle(
                            fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                            fontFamily: TextDandyLight.getFontFamily(),
                            fontWeight: TextDandyLight.getFontWeight(),
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                          child: SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                      builder: (context) => SunsetWeatherPage()),
                                );
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_SUNSET_WEATHER);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 16.0),
                                height: 32.0,
                                width: 32.0,
                                child: Image.asset(
                                    'assets/images/icons/sunset_icon_white.png'),
                              ),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                                onTap: () {
                                  NavigationUtil.onNotificationsSelected(context);
                                  EventSender().sendEvent(eventName: EventNames.NAV_TO_NOTIFICATIONS);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          RotationTransition(
                                              turns: Tween(begin: 0.0, end: -.05)
                                                  .chain(CurveTween(
                                                  curve: Curves.elasticIn))
                                                  .animate(_animationController),
                                              child: Container(
                                                margin: EdgeInsets.only(right: 16.0),
                                                height: 32.0,
                                                width: 32.0,
                                                child: Image.asset(
                                                    'assets/images/collection_icons/reminder_icon_white.png'),
                                              )),
                                        ],
                                      ),
                                    ),
                                    pageState.unseenNotificationCount > 0 ? Container(
                                      margin: EdgeInsets.only(bottom: 16.0),
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: new BoxDecoration(
                                        color: Color(ColorConstants.error_red),
                                        shape: BoxShape.circle,
                                      ),
                                    ) : SizedBox(),
                                  ],
                                )
                            ),
                          ),
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                NavigationUtil.onCalendarSelected(context);
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_CALENDAR);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: 32.0,
                                width: 32.0,
                                child: Image.asset(
                                    'assets/images/icons/calendar_bold_white.png'),
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: offsetAnimationDown,
                            child: GestureDetector(
                              onTap: () {
                                NavigationUtil.onMainSettingsSelected(context);
                                EventSender().sendEvent(eventName: EventNames.NAV_TO_SETTINGS_MAIN);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: 32.0,
                                width: 32.0,
                                child: Image.asset(
                                    'assets/images/icons/settings_icon_white.png'),
                              ),
                            ),
                          ),
                        ],
                        flexibleSpace: new FlexibleSpaceBar(
                          background: Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              SafeArea(
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 78.0),
                                      child: Text(
                                        'DandyLight',
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                          fontSize: 56.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(
                                              ColorConstants.getPrimaryWhite()),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 89.0, top: 48.0),
                                      height: 116.0,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              ImageUtil.LOGIN_BG_LOGO_FLOWER),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pageState.areJobsLoaded ? SliverList(
                          delegate: new SliverChildListDelegate(<Widget>[
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: pageState.activeJobs == null || pageState.activeJobs.length > 0
                                    ? JobsThisWeekHomeCard()
                                    : StartAJobButton(pageState: pageState)),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: ActiveJobsHomeCard()
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: StageStatsHomeCard(pageState: pageState)
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child:  Padding(
                                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Business Insights - ' + DateTime.now().year.toString(),
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                )
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: MonthlyProfitLineChart(pageState: pageState)
                            ),
                            SlideTransition(
                                position: offsetAnimationUp,
                                child: JobTypeBreakdownPieChart()
                            ),
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: buildLeadStatsWidget(pageState),
                              ),
                            ),
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: LeadSourcesPieChart(),
                            ),
                          ])) : SliverList(delegate: SliverChildListDelegate(
                          <Widget>[]
                      )),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      );

  Widget buildLeadStatsWidget(DashboardPageState pageState) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - (25),
            height: 132.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: 'Lead\n Conversion Rate',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 58.0),
                  child: Text(
                    pageState.leadConversionRate.toString() + '%',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: TextDandyLight.getFontFamily(),
                      fontWeight: TextDandyLight.getFontWeight(),
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width / 2) - (25),
            height: 132.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: 'Leads\nUnconverted',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 58.0),
                  child: Text(
                    pageState.unconvertedLeadCount.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: TextDandyLight.getFontFamily(),
                      fontWeight: TextDandyLight.getFontWeight(),
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getFabIcon() {
    if (isFabExpanded) {
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    } else {
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }
}
