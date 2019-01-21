import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
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
                    colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
                    fit: BoxFit.contain,
                  ),
                ),
                child: new CustomScrollView(
                  slivers: <Widget>[
                    new SliverAppBar(
                      pinned: true,
                      forceElevated: true,
//            title: new Text('Vintage Vibes Photography'),
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
                        background: Container(
                          decoration: BoxDecoration(
                            color: const Color(ColorConstants.primary),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/flexible_space_bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding:
                              new EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MaterialButton(
                                height: 35.0,
                                onPressed: _onAddClientPressed,
                                textColor: Colors.white,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                color:
                                    const Color(ColorConstants.primary_bg_grey),
                                splashColor:
                                    const Color(ColorConstants.primary_accent),
                                highlightColor:
                                    const Color(ColorConstants.primary_accent),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color:
                                          const Color(ColorConstants.primary),
                                    ),
                                    Text(
                                      "Client",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(
                                              ColorConstants.primary_accent)),
                                    )
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: 35.0,
                                onPressed: _onAddClientPressed,
                                textColor: Colors.white,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                color:
                                    const Color(ColorConstants.primary_bg_grey),
                                splashColor:
                                    const Color(ColorConstants.primary_accent),
                                highlightColor:
                                    const Color(ColorConstants.primary_accent),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color:
                                          const Color(ColorConstants.primary),
                                    ),
                                    Text(
                                      "Job",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(
                                              ColorConstants.primary_accent)),
                                    )
                                  ],
                                ),
                              ),
                              MaterialButton(
                                height: 35.0,
                                onPressed: _onAddClientPressed,
                                textColor: Colors.white,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                                color:
                                    const Color(ColorConstants.primary_bg_grey),
                                splashColor:
                                    const Color(ColorConstants.primary_accent),
                                highlightColor:
                                    const Color(ColorConstants.primary_accent),
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.search,
                                      color:
                                          const Color(ColorConstants.primary),
                                    ),
                                    Text(
                                      "Search",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: const Color(
                                              ColorConstants.primary_accent)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[])),
                  ],
                ),
              ),
            ),
      );

  _onAddClientPressed() {}
}
