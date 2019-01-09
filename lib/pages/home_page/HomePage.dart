import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, HomePageState>(
        onInit: (store) => store.dispatch(new InitHomePageAction(store.state.homePageState)),
        onDispose: (store) => store.dispatch(new DisposeDataListenersActions(store.state.homePageState)),
        converter: (Store<AppState> store) => HomePageState.create(store),
        builder: (BuildContext context, HomePageState pageState) =>
            new Container(),
      );
}
