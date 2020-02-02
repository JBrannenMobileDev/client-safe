import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
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

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin{
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
    _circleOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _repeatController,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize = Tween<double>(begin: 96.0, end: 175.0)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _circleSize.addListener(() => this.setState(() {}));
    _controller.repeat();
    _repeatController.repeat();
  }

  @override
  void dispose(){
    _repeatController.dispose();
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
                      brightness: Brightness.light,
                      title: Text(
                        'DandyLight',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      titleSpacing: 48.0,
                      backgroundColor:
                          _isMinimized ? _getAppBarColor() : Colors.transparent,
                      elevation: 0.0,
                      pinned: true,
                      floating: false,
                      forceElevated: false,
                      expandedHeight: 315.0,
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: 'Add',
                          onPressed: () {
                            _onAddButtonPressed(context);
                          },
                        ),
                        new IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Settings',
                          onPressed: () {},
                        ),
                      ],
                      flexibleSpace: new FlexibleSpaceBar(
                        background: Stack(
                          alignment: Alignment.topLeft,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 96.0, left: 24.0),
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
                                    padding: EdgeInsets.all(24.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.scaleDown,
                                        image: AssetImage(
                                            "assets/images/job_progress/session_complete.png"),
                                      ),
                                      borderRadius: BorderRadius.circular(48.0),
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                             ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 56.0, top: 232.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Prepare for your shoot!',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w800,
                                      color: Color(
                                          ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Text(
                                    '✔ Camera battery',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
                                      color: Color(
                                          ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Text(
                                    '✔ SD Cards',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
                                      color: Color(
                                          ColorConstants.getPrimaryBlack()),
                                    ),
                                  ),
                                  Text(
                                    '✔ Weather',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
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

  Color _getAppBarColor() {
    if (_scrollController.offset > 260 && _scrollController.offset <= 262) {
      return Colors.black.withOpacity(0.08);
    } else if (_scrollController.offset > 262 &&
        _scrollController.offset <= 263) {
      return Colors.black.withOpacity(0.09);
    } else if (_scrollController.offset > 263 &&
        _scrollController.offset <= 264) {
      return Colors.black.withOpacity(0.10);
    } else if (_scrollController.offset > 264 &&
        _scrollController.offset <= 265) {
      return Colors.black.withOpacity(0.11);
    } else if (_scrollController.offset > 265 &&
        _scrollController.offset <= 266) {
      return Colors.black.withOpacity(0.12);
    } else if (_scrollController.offset > 266 &&
        _scrollController.offset <= 267) {
      return Colors.black.withOpacity(0.13);
    } else if (_scrollController.offset > 267 &&
        _scrollController.offset <= 268) {
      return Colors.black.withOpacity(0.15);
    } else if (_scrollController.offset > 268 &&
        _scrollController.offset <= 269) {
      return Colors.black.withOpacity(0.17);
    } else if (_scrollController.offset > 269 &&
        _scrollController.offset <= 270) {
      return Colors.black.withOpacity(0.19);
    } else if (_scrollController.offset > 270 &&
        _scrollController.offset <= 271) {
      return Colors.black.withOpacity(0.22);
    } else if (_scrollController.offset > 272 &&
        _scrollController.offset <= 273) {
      return Colors.black.withOpacity(0.24);
    } else {
      return Colors.black.withOpacity(0.26);
    }
  }
}
