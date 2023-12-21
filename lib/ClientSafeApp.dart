import 'package:dandylight/AppState.dart';
import 'package:dandylight/navigation/routes/RouteGenerator.dart';
import 'package:dandylight/pages/login_page/LoginPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/PlatformInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'navigation/routes/RouteNames.dart';

class ClientSafeApp extends StatelessWidget {
  final Store<AppState> store;
  const ClientSafeApp(this.store, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light) // Or Brightness.dark
    );
    return StoreProvider<AppState>(
      store: store,
      child: PlatformInfo().isWeb() ? MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false, textScaleFactor: 1), child: child),
        color: Color(ColorConstants.getPrimaryColor()),
        title: 'Dandylight',
        theme: ThemeData(
          primaryColor: Color(ColorConstants.getPrimaryWhite()),
          iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: RouteNames.LANDING_PAGE,
      ) : MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false, textScaleFactor: 1), child: child),
        navigatorKey: GlobalKeyUtil.instance.navigatorKey,
        color: Color(ColorConstants.getPrimaryColor()),
        title: 'Dandylight',
        home: LoginPage(),
        theme: ThemeData(
          primaryColor: Color(ColorConstants.getPrimaryWhite()),
          iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
      ),
    );
  }
}
