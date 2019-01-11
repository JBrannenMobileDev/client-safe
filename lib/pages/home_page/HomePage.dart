import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
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
            Scaffold(
              body: new Container(
                color: const Color(ColorConstants.primary),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                fixedColor: const Color(ColorConstants.primary),
                currentIndex: 0, // this will be set when a new tab is tapped
                items: [
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.dashboard),
                    title: new Text('Dashboard'),
                  ),
                  BottomNavigationBarItem(
                    icon: new Icon(Icons.people),
                    title: new Text('Clients'),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      title: Text('Search')
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      title: Text('Settings')
                  )
                ],
              ),
            ),
      );
}
