import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ClickFieldApp extends StatelessWidget {
  final Store<AppState> store;

  ClickFieldApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'ClickField',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(ColorConstants.primary),
          accentColor: Color(ColorConstants.primary_accent),
          canvasColor: Color(ColorConstants.main_bg),
          cardColor: Colors.white,
          unselectedWidgetColor: Color(ColorConstants.grey),
          textSelectionHandleColor: Color(ColorConstants.primary_accent),
        ),
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/home_page': (BuildContext context) => new HomePage(),
          '/login_page': (BuildContext context) => new LoginPage(),
          '/account_details_page': (BuildContext context) => new AccountDetailsPage(),
        },
      ),
    );
  }
}
