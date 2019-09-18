import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/DashboardActionButtons.dart';
import 'package:client_safe/pages/dashboard_page/widgets/HomeActivityWidget.dart';
import 'package:client_safe/pages/dashboard_page/widgets/HomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/HomeCardTop.dart';
import 'package:client_safe/pages/dashboard_page/widgets/MarketingTile.dart';
import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/DashboardCalendar.dart';
import 'package:client_safe/pages/dashboard_page/widgets/DashboardMessageWidget.dart';
import 'package:client_safe/pages/dashboard_page/widgets/NotificationTile.dart';
import 'package:client_safe/pages/dashboard_page/widgets/job_stats_widget/JobStatsTile.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashbaordPageState>(
        onInit: (store) => store
            .dispatch(new InitDashboardPageAction(store.state.homePageState)),
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) => DashbaordPageState.create(store),
        builder: (BuildContext context, DashbaordPageState pageState) =>
        Scaffold(
          body: Container(
            color: Color(ColorConstants.primary_bg_grey),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Color(ColorConstants.primary),
                  height: 600.0,
                ),
                CustomScrollView(
                  slivers: <Widget>[
                    new SliverAppBar(
                      backgroundColor: const Color(ColorConstants.primary),
                      elevation: 0.0,
                      pinned: true,
                      floating: false,
                      forceElevated: false,
                      expandedHeight: 280.0,
                      actions: <Widget>[
                        new IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: 'Search',
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(
                                const SnackBar(
                                    content: const Text("Under construction")));
                          },
                        ),
                        new IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Settings',
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(
                                const SnackBar(
                                    content: const Text("Under construction")));
                          },
                        ),
                      ],
                      flexibleSpace: new FlexibleSpaceBar(
                        background: Stack(
                          children: <Widget>[
                            HomeActivityWidget(),
                          ],
                        ),
                      ),
                    ),
                    new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          HomeCardTop(),
                          HomeCard(),
                          HomeCard(),
                        ])),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
