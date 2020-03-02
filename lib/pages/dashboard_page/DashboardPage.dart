import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _controller;
  AnimationController _repeatController;
  Animation<double> _circleOpacity;
  Animation<double> _circleSize;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _repeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _circleOpacity =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _repeatController,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize =
        Tween<double>(begin: 96.0, end: 175.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize.addListener(() => this.setState(() {}));
//    _controller.repeat();
//    _repeatController.repeat();
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
        onInit: (store) => {
          store.dispatch(
              new InitDashboardPageAction(store.state.dashboardPageState)),
          store.dispatch(new LoadJobsAction(store.state.dashboardPageState)),
        },
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
          body: Container(
            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryColor()),
                    image: DecorationImage(
                      image: AssetImage(ImageUtil.DANDY_BG),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.contain,
                    ),
                  ),
                  height: 435.0,
                ),
                CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    new SliverAppBar(
                      iconTheme: IconThemeData(
                        color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                      ),
                      brightness: Brightness.light,
                      title: Padding(
                        padding: EdgeInsets.only(left: 32.0),
                        child: Text(
                          'DandyLight',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Blackjack',
                            fontWeight: FontWeight.w800,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      titleSpacing: 48.0,
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      pinned: false,
                      floating: false,
                      forceElevated: false,
                      expandedHeight: 315.0,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                              Icons.event,
                              size: 28.0,
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          tooltip: 'Add',
                          onPressed: () {
                            NavigationUtil.onCalendarSelected(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: 28.0,
                            color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          tooltip: 'Add',
                          onPressed: () {
                            _onAddButtonPressed(context);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              Icons.settings,
                              size: 28.0,
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          tooltip: 'More',
                          onPressed: () {
                            _onAddButtonPressed(context);
                          },
                        ),
                      ],
                      flexibleSpace: new FlexibleSpaceBar(
                        background: Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 56.0),
                              alignment: Alignment.topCenter,
                              child: SafeArea(
                                child: Text(
                                  'Missions',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 112.0, left: 48.0),
                              height: 150.0,
                              width: 150.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  FadeTransition(
                                    opacity: _circleOpacity,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: _circleSize.value,
                                      width: _circleSize.value,
                                      decoration: new BoxDecoration(
                                        color: Colors.white30,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 96.0,
                                    width: 96.0,
                                    padding: EdgeInsets.only(bottom: 18.0, right: 18.0, top: 8.0, left: 8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(48.0),
                                      color: Colors.white,
                                    ),
                                    child: Image.asset(
                                      "assets/images/reminders/welcome_hand.png",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 80.0, top: 242.0),
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: <Widget>[
                                  Text(
                                    'Welcome!',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w800,
                                      color: Color(
                                          ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                ],
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

  void _onAddButtonPressed(BuildContext context) {
    UserOptionsUtil.showDashboardOptionsSheet(context);
  }

  bool get _isMinimized {
    return _scrollController.hasClients && _scrollController.offset > 260.0;
  }
}
