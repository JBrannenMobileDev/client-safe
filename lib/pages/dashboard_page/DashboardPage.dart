import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
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
                      titleSpacing: 48.0,
                      backgroundColor: _isMinimized ? _getAppBarColor() : Colors.transparent,
                      elevation: 0.0,
                      pinned: true,
                      floating: false,
                      forceElevated: false,
                      expandedHeight: 315.0,
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
                          onTap: () {
                            _onAddButtonPressed(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0),
                            height: 28.0,
                            width: 28.0,
                            child: Image.asset('assets/images/icons/plus_icon_white.png'),
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
    } else if (_scrollController.offset > 271 &&
        _scrollController.offset <= 272) {
      return Colors.black.withOpacity(0.19);
    }else if (_scrollController.offset > 272 &&
        _scrollController.offset <= 273) {
      return Colors.black.withOpacity(0.20);
    }else if (_scrollController.offset > 273 &&
        _scrollController.offset <= 274) {
      return Colors.black.withOpacity(0.21);
    }else if (_scrollController.offset > 274 &&
        _scrollController.offset <= 275) {
      return Colors.black.withOpacity(0.22);
    }else if (_scrollController.offset > 275 &&
        _scrollController.offset <= 276) {
      return Colors.black.withOpacity(0.23);
    }else if (_scrollController.offset > 276 &&
        _scrollController.offset <= 277) {
      return Colors.black.withOpacity(0.24);
    }else if (_scrollController.offset > 277 &&
        _scrollController.offset <= 278) {
      return Colors.black.withOpacity(0.25);
    }else if (_scrollController.offset > 278 &&
        _scrollController.offset <= 279) {
      return Colors.black.withOpacity(0.26);
    }else if (_scrollController.offset > 279 &&
        _scrollController.offset <= 280) {
      return Colors.black.withOpacity(0.27);
    }else if (_scrollController.offset > 280 &&
        _scrollController.offset <= 281) {
      return Colors.black.withOpacity(0.28);
    }else if (_scrollController.offset > 281 &&
        _scrollController.offset <= 282) {
      return Colors.black.withOpacity(0.29);
    }else if (_scrollController.offset > 282 &&
        _scrollController.offset <= 283) {
      return Colors.black.withOpacity(0.30);
    }else if (_scrollController.offset > 283 &&
        _scrollController.offset <= 284) {
      return Colors.black.withOpacity(0.32);
    }else if (_scrollController.offset > 284 &&
        _scrollController.offset <= 285) {
      return Colors.black.withOpacity(0.33);
    }else if (_scrollController.offset > 285 &&
        _scrollController.offset <= 286) {
      return Colors.black.withOpacity(0.343);
    }else if (_scrollController.offset > 286 &&
        _scrollController.offset <= 287) {
      return Colors.black.withOpacity(0.35);
    }else if (_scrollController.offset > 287 &&
        _scrollController.offset <= 288) {
      return Colors.black.withOpacity(0.36);
    }else if (_scrollController.offset > 288 &&
        _scrollController.offset <= 289) {
      return Colors.black.withOpacity(0.37);
    }else if (_scrollController.offset > 289 &&
        _scrollController.offset <= 290) {
      return Colors.black.withOpacity(0.38);
    }else if (_scrollController.offset > 290 &&
        _scrollController.offset <= 291) {
      return Colors.black.withOpacity(0.39);
    }
    return Colors.black.withOpacity(0.40);
  }

  Color _getAppBarTextColor(){
    if (_scrollController.offset > 279){
      return Color(ColorConstants.getPrimaryWhite());
    }
    return Color(ColorConstants.getPrimaryBlack());
  }
}
