import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ActiveJobsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobTypeBreakdownPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobsThisWeekHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LeadSourcesPieChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StageStatsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/MonthlyProfitLineChart.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StartAJobButton.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/Profile.dart';
import '../../utils/NotificationHelper.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key key, this.destination, this.comingFromLogin})
      : super(key: key);
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

class _DashboardPageState extends State<HolderPage> with TickerProviderStateMixin {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  ScrollController _scrollController;
  bool dialVisible = true;
  bool isFabExpanded = false;
  bool comingFromLogin;

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

  bool _visible = true;

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

    if((notificationResponse.payload?.isNotEmpty ?? false) && notificationResponse.payload == JobReminder.MILEAGE_EXPENSE_ID) {
      Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
      profile.showNewMileageExpensePage = true;
      ProfileDao.update(profile);
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
        onInit: (store) async {
          store.dispatch(new InitDashboardPageAction(store.state.dashboardPageState));
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState));
          if(store.state.dashboardPageState.unseenNotificationCount > 0) {
            _runAnimation();
          }
          List<JobReminder> allReminders = await JobReminderDao.getAll();
          final notificationHelper = NotificationHelper();
          notificationHelper.setTapBackgroundMethod(notificationTapBackground);
          await notificationHelper.initNotifications();
          if(allReminders.length > 0) {
            NotificationHelper().createAndUpdatePendingNotifications();
          }
        },
        onDidChange: (previous, current) async {
          if(!previous.shouldShowNewMileageExpensePage && current.shouldShowNewMileageExpensePage) {
            UserOptionsUtil.showNewMileageExpenseSelected(context);
          }
          if(!current.hasSeenShowcase) {
            _startShowcase();
            current.onShowcaseSeen();
          }
        },
        onDispose: (store) => store.dispatch(new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
            backgroundColor: Color(ColorConstants.getBlueLight()),
            floatingActionButton: Showcase(
              key: _one,
              targetPadding: EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
              targetShapeBorder: CircleBorder(),
              description: 'Start a new job or \nadd a new contact here!',
              descTextStyle: TextStyle(
                fontSize: 22.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
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
                      child: Text(
                        'Start new job',
                        style: TextStyle(
                          fontFamily: 'simple',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                    onTap: () {
                      UserOptionsUtil.showNewJobDialog(context);
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
                      child: Text(
                        'New contact',
                        style: TextStyle(
                          fontFamily: 'simple',
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
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
                            fontSize: 22.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
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
                            leading: Showcase(
                              key: _two,
                              targetPadding: EdgeInsets.only(right: 13, bottom: 7, top: 6),
                              targetShapeBorder: CircleBorder(),
                              description: 'Sunset & Weather',
                              descTextStyle: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
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
                          new SliverList(
                              delegate: new SliverChildListDelegate(<Widget>[
                                SlideTransition(
                                    position: offsetAnimationUp,
                                    child: pageState.activeJobs == null || pageState.activeJobs.length > 0
                                        ? JobsThisWeekHomeCard()
                                        : StartAJobButton(pageState: pageState)),
                                SlideTransition(
                                    position: offsetAnimationUp,
                                    child: StageStatsHomeCard(pageState: pageState)
                                ),
                                SlideTransition(
                                    position: offsetAnimationUp,
                                    child: ActiveJobsHomeCard()
                                ),
                                SlideTransition(
                                    position: offsetAnimationUp,
                                    child:  Padding(
                                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                      child: Text(
                                        'Business Insights - ' + DateTime.now().year.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants.getPrimaryWhite()),
                                        ),
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
                              ])),
                        ],
                      ),
                    ],
                  ),
                ),
            ),
      );

  Widget buildLeadStatsWidget(DashboardPageState pageState) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - (25),
            height: 120.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lead Conversion Rate',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 42.0),
                  child: Text(
                    pageState.leadConversionRate.toString() + '%',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 42.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w500,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: (MediaQuery.of(context).size.width / 2) - (25),
            height: 120.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Unconverted Leads',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 42.0),
                  child: Text(
                    pageState.unconvertedLeadCount.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 42.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w500,
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
