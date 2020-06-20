import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/SwipeableCardsWidget.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key, this.destination, this.comingFromLogin}) : super(key: key);
  final DashboardPage destination;
  final bool comingFromLogin;

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState(comingFromLogin);
  }
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  bool dialVisible = true;
  bool isFabExpanded = false;
  bool comingFromLogin;

  _DashboardPageState(this.comingFromLogin);

  AnimationController controller;
  Tween<Offset> offsetUpTween;
  Tween<Offset> offsetDownTween;

  initState() {
    super.initState();

    offsetUpTween = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );
    offsetDownTween = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );
    if(comingFromLogin) {
      controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
      controller.forward();
    }else {
      controller = AnimationController(duration: const Duration(milliseconds: 0), vsync: this);
      controller.forward();
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

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        onInit: (store) async {
          store.dispatch(
              new InitDashboardPageAction(store.state.dashboardPageState));
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState));
        },
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.getBlueLight()),
          floatingActionButton: SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
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
            backgroundColor: Color(ColorConstants.getPrimaryColor()),
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
                  UserOptionsUtil.showNewContactDialog(context);
                },
              ),
            ],
          ),
          body: Container(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
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
                      expandedHeight: 315.0,
                      leading: SlideTransition(
                        position: offsetAnimationDown,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                  builder: (context) => SunsetWeatherPage()),
                            );
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
                      actions: <Widget>[
                        SlideTransition(
                          position: offsetAnimationDown,
                          child: GestureDetector(
                            onTap: () {
                              NavigationUtil.onCalendarSelected(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16.0),
                              height: 28.0,
                              width: 28.0,
                              child: Image.asset(
                                  'assets/images/icons/calendar_bold_white.png'),
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: offsetAnimationDown,
                          child: GestureDetector(
                            onTap: null,
                            child: Container(
                              margin: EdgeInsets.only(right: 16.0),
                              height: 28.0,
                              width: 28.0,
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
                                      margin: EdgeInsets.only(top: 64.0),
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
                                      margin: EdgeInsets.only(
                                          left: 89.0, top: 37.0),
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
                            SlideTransition(
                              position: offsetAnimationUp,
                              child: Container(
                                width: 175.0,
                                margin: EdgeInsets.only(top: 172.0),
                                child: Text(
                                  'Capture the moment We\'ll do the rest',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 238.0),
                              child: SwipeableCardsWidget(MediaQuery.of(context).size.width),
                            ),
                          ],
                        ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                      SlideTransition(
                          position: offsetAnimationUp,
                          child: JobsHomeCard(pageState: pageState)),
                      SlideTransition(
                          position: offsetAnimationUp,
                          child: LeadsHomeCard(
                              cardTitle: 'Leads', pageState: pageState)),
                      SlideTransition(
                          position: offsetAnimationUp,
                          child: StatsHomeCard(
                              cardTitle: "Business Insights",
                              pageState: pageState)),
                    ])),
                  ],
                  ),
                ],
            ),
          ),
        ),
      );

  getFabIcon() {
    if (isFabExpanded) {
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    } else {
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }
}
