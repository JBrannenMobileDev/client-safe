import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/pages/login_page/LoginPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ClientSafeApp extends StatelessWidget {
  final Store<AppState> store;
  ClientSafeApp(this.store);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light) // Or Brightness.dark
    );
    return new StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        builder: (context, child) =>
            MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false), child: child),
        navigatorKey: GlobalKeyUtil.instance.navigatorKey,
        color: Color(ColorConstants.getPrimaryColor()),
        title: 'dandylight',
        home: LoginPage(),
        theme: ThemeData(
          primaryColor: Color(ColorConstants.getPrimaryColor()),
          iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
      ),
    );
  }
}
