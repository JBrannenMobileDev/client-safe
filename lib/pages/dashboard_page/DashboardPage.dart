import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/HomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/NotificationsCard.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({ Key key, this.destination }) : super(key: key);

  final DashboardPage destination;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        onInit: (store) => store
            .dispatch(new InitDashboardPageAction(store.state.dashboardPageState)),
        onDispose: (store) => store.dispatch(
            new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
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

                          },
                        ),
                        new IconButton(
                          icon: const Icon(Icons.settings),
                          tooltip: 'Settings',
                          onPressed: () {

                          },
                        ),
                      ],
                      flexibleSpace: new FlexibleSpaceBar(
                        background: Stack(
                          children: <Widget>[
                            Container(
                              height: 150.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          NotificationsCard(pageState: pageState),
                          HomeCard(
                            cardHeight: 200.0,
                            paddingLeft: 26.0,
                            paddingTop: 0.0,
                            paddingRight: 26.0,
                            paddingBottom: 20.0,
                            cardContents: Container(),
                          ),
                          HomeCard(
                            cardHeight: 200.0,
                            paddingLeft: 26.0,
                            paddingTop: 0.0,
                            paddingRight: 26.0,
                            paddingBottom: 20.0,
                            cardContents: Container(),
                          ),
                        ])),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
