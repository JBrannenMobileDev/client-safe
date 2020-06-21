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

class CreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountPageState();
  }
}

class _CreateAccountPageState extends State<CreateAccountPage> with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );

    _controllerLogoOut = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() =>
        setState(() {}));

    sunOffsetTween = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
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
              ScaleTransition(
                scale: Tween(begin: 8.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controllerLogoOut,
                    curve: new Interval(
                      0.0,
                      0.5,
                      curve: Curves.elasticOut,
                    ),
                  ),
                ),
                child: TranslationImage(
                  image: AssetImage(ImageUtil.LOGIN_BG_SUN),
                  controller: _controller,
                  animations: [
                    sunStep2,
                  ],
                ),
              ),
              SafeArea(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 64.0),
                      child: Text(
                        'DandyLight',
                        style: TextStyle(
                          fontSize: 56.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(
                              ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 89.0, top: 37.0),
                      height: 116.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(
                              ImageUtil.LOGIN_BG_LOGO_FLOWER),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
