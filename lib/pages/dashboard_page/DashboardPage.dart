import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/DashboardActionButtons.dart';
import 'package:client_safe/pages/dashboard_page/widgets/DashboardCalendar.dart';
import 'package:client_safe/pages/dashboard_page/widgets/DashboardMessageWidget.dart';
import 'package:client_safe/pages/dashboard_page/widgets/NotificationTile.dart';
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
                decoration: BoxDecoration(
                  color: const Color(ColorConstants.primary_bg_grey),
                  image: DecorationImage(
                    image: AssetImage('assets/images/cameras_background.jpg'),
                    repeat: ImageRepeat.repeat,
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.05), BlendMode.dstATop),
                    fit: BoxFit.contain,
                  ),
                ),
                child: new CustomScrollView(
                  slivers: <Widget>[
                    new SliverAppBar(
                      backgroundColor: const Color(ColorConstants.primary),
                      pinned: false,
                      floating: true,
                      snap: false,
                      forceElevated: true,
                      expandedHeight: 200.0,
                      actions: <Widget>[
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
                            DashboardActionButtons(),
                            DashboardMessageWidget(),
                          ],
                        ),
                      ),
                    ),
                    new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                      DashboardCalendar(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: NotificationTile(title: "Job Alerts", count: "1",),
                          ),
                          Expanded(
                            child: NotificationTile(title: "Client Alerts", count: "3",),
                          ),
                        ],
                      )
                    ])),
                  ],
                ),
              ),
            ),
      );
}
