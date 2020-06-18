import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadsHomeCard.dart';
import 'package:client_safe/pages/dashboard_page/widgets/StatsHomeCard.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
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
                width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryColor()),
              image: DecorationImage(
                image: AssetImage(ImageUtil.LOGIN_BG),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 116.0, bottom: 332.0),
                    child: Text(
                      'DandyLight',
                      style: TextStyle(
                        fontSize: 64.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 24.0),
                      alignment: Alignment.centerLeft,
                      height: 64.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(36.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            height: 42.0,
                            width: 42.0,
                            child: Image.asset('assets/images/icons/facebook_icon_black.png'),
                          ),
                          Text(
                            'Sign in with Facebook',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0),
                      padding: EdgeInsets.only(left: 24.0),
                      alignment: Alignment.centerLeft,
                      height: 64.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(36.0)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            height: 42.0,
                            width: 42.0,
                            child: Image.asset('assets/images/icons/gmail_icon_black.png'),
                          ),
                          Text(
                            'Sign in with Gmail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      height: 64.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(36.0)
                      ),
                      child: Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        NavigationUtil.onSuccessfulLogin(context);
                      },
                      child: Text(
                        ' or Login',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
