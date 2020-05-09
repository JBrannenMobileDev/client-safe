import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key, this.destination}) : super(key: key);
  final DashboardPage destination;

  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin{
  ScrollController _scrollController;
  AnimationController _controller;
  AnimationController _repeatController;
  Animation<double> _circleSize;
  bool dialVisible = true;
  bool isFabExpanded = false;

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _repeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _circleSize =
        Tween<double>(begin: 96.0, end: 175.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize.addListener(() => this.setState(() {}));

    _scrollController = ScrollController()..addListener(() {
        setDialVisible(_scrollController.position.userScrollDirection == ScrollDirection.forward);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _repeatController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        onInit: (store) async {
          store.dispatch(new InitDashboardPageAction(store.state.dashboardPageState));
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState));
        },
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
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
                    new SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                      brightness: Brightness.light,
                      title: Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      centerTitle: true,
                      titleSpacing: 48.0,
                      backgroundColor:
                      Colors.transparent,
                      elevation: 0.0,
                      pinned: false,
                      floating: false,
                      forceElevated: false,
                      expandedHeight: 315.0,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => SunsetWeatherPage()),
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
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            NavigationUtil.onCalendarSelected(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0),
                            height: 28.0,
                            width: 28.0,
                            child: Image.asset('assets/images/icons/calendar_icon_white.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: null,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0),
                            height: 28.0,
                            width: 28.0,
                            child: Image.asset('assets/images/icons/settings_icon_white.png'),
                          ),
                        ),
                      ],
                      flexibleSpace: new FlexibleSpaceBar(
                        background: Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            Container(
                              height: 700.0,
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                "assets/images/backgrounds/dashboard_flowers_image.png",
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 135.0, right: 32.0),
                              child: Text(
                                'DandyLight',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 42.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w900,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                            Container(
                              width: 175.0,
                              margin: EdgeInsets.only(bottom: 75.0, right: 32.0),
                              child: Text(
                                'Capture the moment We\'ll do the rest',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                      JobsHomeCard(pageState: pageState),
                      LeadsHomeCard(cardTitle: 'Leads', pageState: pageState),
                      StatsHomeCard(
                          cardTitle: "Insights", pageState: pageState),
                    ])),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  getFabIcon() {
    if(isFabExpanded){
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    }else{
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }
}
