import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/home_page/HomePage.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPage.dart';
import 'package:client_safe/pages/new_job_page/NewJobPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPage.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
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
        title: 'DandyLight',
        home: HomePage(),
        theme: ThemeData(
          primaryColor: Color(ColorConstants.getPrimaryColor()),
          iconTheme: IconThemeData(color: Color(ColorConstants.getPrimaryBlack())),
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
              color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ),
        initialRoute: '/home',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/home': (context) => HomePage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/new_job_route': (context) => NewJobPage(),
          '/new_contact_route': (context) => NewContactPage(),
          '/new_price_package_route': (context) => NewPricingProfilePage(),
          '/new_location_route': (context) => NewLocationPage(),
        },
      ),
    );
  }
}
