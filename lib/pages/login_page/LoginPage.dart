import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) =>
            Scaffold(
          body: Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Text(
                  'DandyLight',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontFamily: 'Blackjack',
                    fontWeight: FontWeight.w800,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryColor()),
                    image: DecorationImage(
                      image: AssetImage(ImageUtil.DANDY_BG),
                      repeat: ImageRepeat.repeat,
                      fit: BoxFit.contain,
                    ),
                  ),
                  height: 435.0,
                ),
                NewContactTextField(
                    null,
                    "User name",
                    TextInputType.text,
                    60.0,
                    null,
                    '',
                    TextInputAction.next,
                    null,
                    null,
                    TextCapitalization.words,
                    null),
                NewContactTextField(
                    null,
                    "Password",
                    TextInputType.text,
                    60.0,
                    null,
                    '',
                    TextInputAction.next,
                    null,
                    null,
                    TextCapitalization.words,
                    null),
              ],
            ),
          ),
        ),
      );
}
