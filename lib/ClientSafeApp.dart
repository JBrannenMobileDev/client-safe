import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ClientSafeApp extends StatelessWidget {
  final Store<AppState> store;

  ClientSafeApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Vintage Vibes Photography',
        theme: ThemeData(
            primaryColor: Color(0xff6fdeb6),
            accentColor: Color(0xffe5e4e2),
            primaryColorDark: Color(0xff19b587)),
        home: HomePage(),
      ),
    );
  }
}
