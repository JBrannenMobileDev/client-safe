import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/widgets/login_animations/TranslationImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _controllerLogoIn;
  AnimationController _controllerLogoOut;
  Tween<Offset> peachMountainOffsetTween;
  Tween<Offset> peachDarkMountainOffsetTween;
  Tween<Offset> blueDarkMountainOffsetTween;
  Tween<Offset> sunOffsetTween;
  Tween<double> opacityTween;
  Tween<double> marginTopTween;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerLogoIn = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _controllerLogoOut = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() =>
        setState(() {}));

    peachMountainOffsetTween = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    peachDarkMountainOffsetTween = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    blueDarkMountainOffsetTween = new Tween<Offset>(
      begin: const Offset(2.0, 1.0),
      end: Offset.zero,
    );

    sunOffsetTween = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );

    opacityTween = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    marginTopTween = new Tween<double>(
      begin: 0.0,
      end: 124.0,
    );



    _controller.forward();
    _controllerLogoIn.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerLogoIn.dispose();
    _controllerLogoOut.dispose();
  }

  Animation<Offset> get lightPeachMountainsStep1 => peachMountainOffsetTween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.0,
        0.75,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<Offset> get peachDarkMountainsStep2 => peachDarkMountainOffsetTween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.1,
        0.85,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<Offset> get sunStep2 => sunOffsetTween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.1,
        0.85,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<Offset> get darkBlueMountainsStep3 => blueDarkMountainOffsetTween.animate(
    new CurvedAnimation(
      parent: _controller,
      curve: new Interval(
        0.2,
        0.95,
        curve: Curves.ease,
      ),
    ),
  );

  Animation<double> get marginTopLogoOut => marginTopTween.animate(
    new CurvedAnimation(
      parent: _controllerLogoOut,
      curve: Curves.ease,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, DashboardPageState>(
        converter: (Store<AppState> store) =>
            DashboardPageState.fromStore(store),
        builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getBlueLight()),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              TranslationImage(
                image: AssetImage(ImageUtil.LOGIN_BG_SUN),
                controller: _controller,
                animations: [
                  sunStep2,
                ],
              ),
              TranslationImage(
                image: AssetImage(ImageUtil.LOGIN_BG_BLUE_MOUNTAIN),
                controller: _controller,
                animations: [
                  darkBlueMountainsStep3,
                ],
              ),
              TranslationImage(
                image: AssetImage(ImageUtil.LOGIN_BG_PEACH_DARK_MOUNTAIN),
                controller: _controller,
                animations: [
                  peachDarkMountainsStep2,
                ],
              ),
              TranslationImage(
                image: AssetImage(ImageUtil.LOGIN_BG_PEACH_MOUNTAIN),
                controller: _controller,
                animations: [
                  lightPeachMountainsStep1,
                ],
              ),
              SlideTransition(
                position: lightPeachMountainsStep1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(bottom: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.only(left: 24.0),
                          alignment: Alignment.centerLeft,
                          height: 64.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(36.0)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: 42.0,
                                width: 42.0,
                                child: Image.asset(
                                    'assets/images/icons/facebook_icon_black.png'),
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
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          padding: EdgeInsets.only(left: 24.0),
                          alignment: Alignment.centerLeft,
                          height: 64.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(36.0)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: 42.0,
                                width: 42.0,
                                child: Image.asset(
                                    'assets/images/icons/gmail_icon_black.png'),
                              ),
                              Text(
                                'Sign in with Google',
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
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 16.0),
                          alignment: Alignment.center,
                          height: 64.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              borderRadius: BorderRadius.circular(36.0)),
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
                            _controller.reverse();
                            _controllerLogoOut.forward();
                            setState(() {
                              isSelected = true;
                            });
                            Timer(const Duration(milliseconds: 600), () {
                              NavigationUtil.onSuccessfulLogin(context);
                            });
                          },
                          child: Text(
                            ' or Login',
                            style: TextStyle(
                              fontSize: 22.0,
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
              SafeArea(
                child: ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controllerLogoIn,
                      curve: new Interval(
                        0.0,
                        0.5,
                        curve: Curves.elasticOut,
                      ),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween(begin: 1.0, end: 0.777777).animate(
                      CurvedAnimation(
                        parent: _controllerLogoOut,
                        curve: Curves.ease,
                        ),
                      ),
                    child: Transform.translate(
                    offset: Offset(0.0, -marginTopLogoOut.value),
                    child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 136),
                          child: AnimatedDefaultTextStyle(
                            style: isSelected
                                ? TextStyle(
                              fontSize: 72.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite())
                                  .withOpacity(1.0),
                            )
                                : TextStyle(
                              fontSize: 72.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite())
                                  .withOpacity(1.0),
                            ),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Text(
                              'DandyLight',
                            ),
                          ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 230.0, left: 114.0, top: 102.0),
                        height: 150.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: AssetImage(ImageUtil.LOGIN_BG_LOGO_FLOWER),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
                ),
              ),
            ],
          ),
        ),
      );
}
