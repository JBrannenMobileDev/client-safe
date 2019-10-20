import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
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
        navigatorKey: GlobalKeyUtil.instance.navigatorKey,
        color: const Color(ColorConstants.primary),
        title: 'Client Safe',
        home: HomePage(),
        theme: ThemeData(
          primaryColor: Color(ColorConstants.primary),
          iconTheme: IconThemeData(color: Colors.white),
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              color: Colors.white
          ),
        ),
      ),
    );
  }
}
