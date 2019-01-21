import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class DashboardPage extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashbaordPageState>(
  onInit: (store) => store.dispatch(new InitDashboardPageAction(store.state.homePageState)),
  onDispose: (store) => store.dispatch(new DisposeDataListenersActions(store.state.homePageState)),
  converter: (Store<AppState> store) => DashbaordPageState.create(store),
  builder: (BuildContext context, DashbaordPageState pageState) => Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            pinned: true,
            forceElevated: true,
//            title: new Text('Vintage Vibes Photography'),
            expandedHeight: pageState.flexibleSpaceHeight,
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                      content: const Text("Under construction")));
                },
              ),
            ],
            flexibleSpace:
                new FlexibleSpaceBar(background: new RecentActivityWidget()),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: _onAddClientPressed,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  color: const Color(ColorConstants.primary_bg_grey),
                  splashColor: const Color(ColorConstants.primary_accent),
                  highlightColor: const Color(ColorConstants.primary_accent),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: const Color(ColorConstants.primary_light),
                      ),
                      Text(
                        "Client",
                        style: TextStyle(
                            color: const Color(ColorConstants.primary_light)),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _onAddClientPressed,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  color: const Color(ColorConstants.primary_bg_grey),
                  splashColor: const Color(ColorConstants.primary_accent),
                  highlightColor: const Color(ColorConstants.primary_accent),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: const Color(ColorConstants.primary_light),
                      ),
                      Text(
                        "Job",
                        style: TextStyle(
                            color: const Color(ColorConstants.primary_light)),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: _onAddClientPressed,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                  color: const Color(ColorConstants.primary_bg_grey),
                  splashColor: const Color(ColorConstants.primary_accent),
                  highlightColor: const Color(ColorConstants.primary_accent),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        color: const Color(ColorConstants.primary_light),
                      ),
                      Text(
                        "Search",
                        style: TextStyle(
                            color: const Color(ColorConstants.primary_light)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ])),
        ],
      ),
    ),
  );

  _onAddClientPressed() {}

