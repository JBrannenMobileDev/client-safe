import 'dart:async';
import 'dart:ui';
import 'package:dandylight/widgets/bouncing_loading_animation/BouncingLoadingAnimatedIcon.dart';
import 'package:dandylight/widgets/bouncing_loading_animation/LoginLoadingWidget.dart';
import 'package:flutter/services.dart';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/LoginTextField.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/widgets/login_animations/TranslationImage.dart';
import 'package:dandylight/widgets/login_animations/TranslationWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  static const String SIGN_IN_WITH_GOOGLE = 'Sign in with Google';
  static const String SIGN_IN_WITH_FACEBOOK = 'Sign in with Facebook';
  static const String CREATE_ACCOUNT = 'Create Account';

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController businessNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController loginEmailTextController = TextEditingController();
  TextEditingController loginPasswordTextController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final businessNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final loginEmailFocusNode = FocusNode();
  final loginPasswordFocusNode = FocusNode();

  AnimationController _controller;
  AnimationController _controllerLogoIn;
  AnimationController _controllerLogoOut;
  AnimationController _controllerCreateAccount;
  AnimationController _controllerSunIn;
  AnimationController _controllerLoginView;
  AnimationController _controllerErrorShake;
  AnimationController _controllerLoginErrorShake;
  AnimationController _controllerSlideUp;
  Tween<Offset> peachMountainOffsetTween;
  Tween<Offset> peachDarkMountainOffsetTween;
  Tween<Offset> blueDarkMountainOffsetTween;
  Tween<Offset> sunOffsetTween;
  Tween<Offset> backArrowOffsetTween;
  Tween<Offset> mainButtonsOffsetTween;
  Tween<Offset> loginButtonsOffsetTween;
  Tween<Offset> slideUpTween;
  Tween<double> opacityTween;
  Tween<double> marginTopTween;
  Tween<double> marginTopCreateAccountTween;
  Tween<double> sunHeightTween;
  Tween<double> sunRadiusTween;
  String selectedButton;

  @override
  void initState() {
    super.initState();
    loginEmailFocusNode.addListener(() {
      if(loginEmailFocusNode.hasFocus || loginPasswordFocusNode.hasFocus){
        _controllerSlideUp.forward();
      } else {
        _controllerSlideUp.reverse();
      }
    });

    loginPasswordFocusNode.addListener(() {
      if(loginEmailFocusNode.hasFocus || loginPasswordFocusNode.hasFocus){
        _controllerSlideUp.forward();
      } else {
        _controllerSlideUp.reverse();
      }
    });

    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerLogoIn = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _controllerSunIn = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerLogoOut = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() =>
        setState(() {}));

    _controllerLoginView = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerCreateAccount = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() =>
        setState(() {}));

    _controllerErrorShake = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerLoginErrorShake = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _controllerSlideUp = new AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

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

    backArrowOffsetTween = new Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    );

    sunOffsetTween = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );

    mainButtonsOffsetTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0.0),
    );

    loginButtonsOffsetTween = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    );

    slideUpTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.225),
    );

    opacityTween = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    marginTopTween = new Tween<double>(
      begin: 0.0,
      end: 124.0,
    );

    marginTopCreateAccountTween = new Tween<double>(
      begin: 0.0,
      end: 156.0,
    );

    sunHeightTween = new Tween<double>(
      begin: 1,
      end: 8,
    );

    sunRadiusTween = new Tween<double>(
      begin: 150,
      end: 0,
    );



    _controller.forward();
    _controllerLogoIn.forward();
    _controllerSunIn.forward();
    _controllerLoginErrorShake.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerLogoIn.dispose();
    _controllerLogoOut.dispose();
    _controllerCreateAccount.dispose();
    _controllerSunIn.dispose();
    _controllerLoginView.dispose();
    _controllerErrorShake.dispose();
    _controllerSlideUp.dispose();
    _controllerLoginErrorShake.dispose();
  }

  Animation<Offset> get slideUpAnimation => slideUpTween.animate(
    new CurvedAnimation(
      parent: _controllerSlideUp,
      curve: Curves.ease,
    ),
  );

  Animation<Offset> get backArrowTranslation => backArrowOffsetTween.animate(
    new CurvedAnimation(
      parent: _controllerCreateAccount,
      curve: Curves.ease,
    ),
  );

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
      parent: _controllerSunIn,
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

  Animation<double> get marginTopCreateAccount => marginTopCreateAccountTween.animate(
    new CurvedAnimation(
      parent: _controllerCreateAccount,
      curve: Curves.ease,
    ),
  );

  Animation<double> get sunSize => sunHeightTween.animate(
    new CurvedAnimation(
      parent: _controllerCreateAccount,
      curve: Curves.ease,
    ),
  );

  Animation<double> get sunRadius => sunRadiusTween.animate(
    new CurvedAnimation(
      parent: _controllerCreateAccount,
      curve: Curves.ease,
    ),
  );

  Animation<Offset> get hideMainButtonsStep => mainButtonsOffsetTween.animate(
    new CurvedAnimation(
      parent: _controllerLoginView,
      curve: Curves.ease,
    ),
  );

  Animation<Offset> get showLoginButtonsStep => loginButtonsOffsetTween.animate(
    new CurvedAnimation(
      parent: _controllerLoginView,
      curve: Curves.ease,
    ),
  );

  bool updateCurrentUserStatus = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginPageState>(
        onInit: (appState) {
          appState.dispatch(CheckForCurrentUserAction(appState.state.loginPageState));
        },
        onWillChange: (pageStateCurrent, pageStatePrevious) {
          if(pageStatePrevious.mainButtonsVisible != pageStateCurrent.mainButtonsVisible){
            if(pageStateCurrent.mainButtonsVisible){
              _controllerLoginView.forward();
            }else {
              _controllerLoginView.reverse();
            }
          }
        },
        onDidChange: (pageState) {
          if(pageState.navigateToHome) {
            _onStartAnimationForGoingToHomePage();
          }
          if(pageState.createAccountErrorMessage.isNotEmpty){
            _controllerErrorShake.reset();
            _controllerErrorShake.forward();
          }
          if(pageState.shouldShowAccountCreatedDialog){
            UserOptionsUtil.showAccountCreatedDialog(context, pageState.user);
            pageState.resetShouldShowSuccessDialog();
            _onBackPressed(pageState);
          }
          if(pageState.showLoginErrorAnimation){
            _controllerLoginErrorShake.reset();
            _controllerLoginErrorShake.forward();
            pageState.onClearLoginErrorShake();
          }
          if(pageState.emailAddress.isNotEmpty && loginEmailTextController.text != pageState.emailAddress)loginEmailTextController.text = pageState.emailAddress;
          if(pageState.password.isNotEmpty && loginPasswordTextController.text != pageState.password)loginPasswordTextController.text = pageState.password;
        },
        converter: (Store<AppState> store) => LoginPageState.fromStore(store),
        builder: (BuildContext context, LoginPageState pageState) => Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color(ColorConstants.getBlueLight()),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              TranslationWidget(
                controller: _controllerSunIn,
                  animations: [
                    sunStep2,
                  ],
                widget: Container(
                  height: 130.0 * sunSize.value,
                  width:  260.0 * sunSize.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(sunRadius.value), bottomRight: Radius.circular(sunRadius.value)),
                    color: Color(ColorConstants.getPrimaryColor()),
                  ),
                ),
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
              !pageState.isUserVerified ? SlideTransition(
                position: lightPeachMountainsStep1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    SlideTransition(
                    position: hideMainButtonsStep,
                    child: GestureDetector(
                        onTap: () {
                          DandyToastUtil.showToast('Sign in with Facebook is not ready yet.', Color(ColorConstants.getPrimaryColor()));
                        },
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
                    ),
                  SlideTransition(
                    position: hideMainButtonsStep,
                    child: GestureDetector(
                        onTap: () {
                          DandyToastUtil.showToast('Sign in with Google is not ready yet.', Color(ColorConstants.getPrimaryColor()));
//                          _controller.reverse();
//                          Timer(const Duration(milliseconds: 500), () {
//                            setState(() {
//                              selectedButton = SIGN_IN_WITH_GOOGLE;
//                            });
//                          });
//                          Timer(const Duration(milliseconds: 250), () {
//                            _controllerCreateAccount.forward();
//                          });
                        },
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
                  ),
                  SlideTransition(
                    position: hideMainButtonsStep,
                    child: GestureDetector(
                        onTap: () {
                          _controller.reverse();
                          Timer(const Duration(milliseconds: 500), () {
                            setState(() {
                              selectedButton = CREATE_ACCOUNT;
                            });
                          });
                          Timer(const Duration(milliseconds: 250), () {
                            _controllerCreateAccount.forward();
                          });
                        },
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
                  ),
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            if(pageState.mainButtonsVisible){
                              pageState.updateMainButtonVisible(false);
                            }else {
                              pageState.updateMainButtonVisible(true);
                            }
                          },
                          child: Text(
                            pageState.mainButtonsVisible ? 'Sign in' : 'Create account',
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
              ) : SizedBox(),
          !pageState.isUserVerified ? pageState.showResendMessage ? SlideTransition(
            position: lightPeachMountainsStep1,
            child:Container(
                height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 316.0),
                      child: ScaleTransition(
                        scale: Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _controllerLoginErrorShake,
                            curve: new Interval(
                              0.0,
                              0.5,
                              curve: Curves.elasticOut,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Verification is incomplete.',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pageState.onResendEmailVerificationSelected();
                              },
                              child: Container(
                                height: 32.0,
                                width: 88.0,
                                margin: EdgeInsets.only(left: 8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPeachDark()),
                                    borderRadius: BorderRadius.circular(24.0)),
                                child: Text(
                                  'Resend',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Color(ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox() : SizedBox(),
            SlideTransition(
              position: slideUpAnimation,
            child: SlideTransition(
                position: lightPeachMountainsStep1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(bottom: 74.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SlideTransition(
                        position: showLoginButtonsStep,
                        child: Text(
                          pageState.loginErrorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w800,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      !pageState.showLoginLoadingAnimation ? SlideTransition(
                        position: showLoginButtonsStep,
                        child: LoginTextField(
                          controller: loginEmailTextController,
                          hintText: 'Email address',
                          labelText: 'Email address',
                          inputType: TextInputType.emailAddress,
                          height: 64.0,
                          inputTypeError: 'Email address is required',
                          onTextInputChanged: (email) => pageState.onLoginEmailChanged(email),
                          onEditingCompleted: null,
                          keyboardAction: TextInputAction.next,
                          focusNode: loginEmailFocusNode,
                          onFocusAction: () {
                            loginEmailFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(loginPasswordFocusNode);
                          },
                          capitalization: TextCapitalization.none,
                          enabled: true,
                          obscureText: false,
                        ),
                      ) : SizedBox(),
                      !pageState.showLoginLoadingAnimation ? SlideTransition(
                        position: showLoginButtonsStep,
                        child: LoginTextField(
                          controller: loginPasswordTextController,
                          hintText: 'Password',
                          labelText: 'Password',
                          inputType: TextInputType.text,
                          height: 64.0,
                          inputTypeError: 'Password is required',
                          onTextInputChanged: (password) => pageState.onLoginPasswordChanged(password),
                          onEditingCompleted: null,
                          keyboardAction: TextInputAction.done,
                          focusNode: loginPasswordFocusNode,
                          onFocusAction: () {
                            loginPasswordFocusNode.unfocus();
                            _controllerSlideUp.reverse();
                          },
                          capitalization: TextCapitalization.none,
                          enabled: true,
                          obscureText: true,
                        ),
                      ) : SizedBox(),
                      SlideTransition(
                        position: showLoginButtonsStep,
                        child: GestureDetector(
                          onTap: () {
                            pageState.onLoginSelected();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 16.0),
                            alignment: Alignment.center,
                            height: 64.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                                color: Color(ColorConstants.getPrimaryWhite()),
                                borderRadius: BorderRadius.circular(36.0)),
                            child: pageState.showLoginLoadingAnimation
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Loading',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 30.0, left: 4.0),
                                  child: BouncingLoadingAnimatedIcon(),
                                )
                              ],
                            ) : Text(
                              'Sign in',
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
                      ),
                    ],
                  ),
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
                        parent: _controllerCreateAccount,
                        curve: Curves.ease,
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
                        offset: Offset(0.0, -marginTopCreateAccount.value),
                        child: Transform.translate(
                          offset: Offset(0.0, -marginTopLogoOut.value),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 136),
                                child: AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                          fontSize: 72.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w600,
                                          color: Color(ColorConstants
                                                  .getPrimaryWhite())
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
                                    image: AssetImage(
                                        ImageUtil.LOGIN_BG_LOGO_FLOWER),
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
                ),
              ),
              selectedButton != null ? SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 96.0),
                  child: Text(
                    selectedButton,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ) : SizedBox(),
              _getLoginTextFieldWidgets(selectedButton, pageState),
              selectedButton == CREATE_ACCOUNT ? SafeArea(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      pageState.onCreateAccountSubmitted();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0, left: 84.0, right: 84.0),
                      alignment: Alignment.center,
                      height: 64.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPeachDark()),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: pageState.showCreateAccountLoadingAnimation
                          ? Center(child: LoginLoadingWidget())
                          : Text(
                        'Submit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : selectedButton == SIGN_IN_WITH_GOOGLE ? SafeArea(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      pageState.onContinueWithGoogleSubmitted();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0, left: 64.0, right: 64.0),
                      alignment: Alignment.center,
                      height: 64.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPeachDark()),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Text(
                        'Sign in with Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(),
              Positioned(
                left: 8.0,
                child: SafeArea(
                  child: TranslationWidget(
                    widget: IconButton(
                        icon: Icon(Device.get().isIos
                            ? CupertinoIcons.back
                            : Icons.arrow_back),
                        color: Color(ColorConstants.getPrimaryWhite()),
                        iconSize: 36,
                        onPressed: () {
                          _onBackPressed(pageState);
                        },
                      ),
                    controller: _controller,
                    animations: [
                      backArrowTranslation,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _onStartAnimationForGoingToHomePage(){
    _controller.reverse();
    _controllerLogoOut.forward();
    _controllerSunIn.reverse();
    Timer(const Duration(milliseconds: 600), () {
      NavigationUtil.onSuccessfulLogin(context);
    });
  }

  Widget _getLoginTextFieldWidgets(String selectedButton, LoginPageState pageState) {
    if(selectedButton != null) {
      return SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 148.0),
          child: ListView(
            children: <Widget>[
              LoginTextField(
                controller: firstNameTextController,
                hintText: 'First name',
                labelText: 'First name',
                inputType: TextInputType.text,
                height: 64.0,
                inputTypeError: 'First name is required',
                onTextInputChanged: (firstNameText) => pageState.onFirstNameChanged(firstNameText),
                onEditingCompleted: null,
                keyboardAction: TextInputAction.next,
                focusNode: firstNameFocusNode,
                onFocusAction: () {
                  firstNameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(lastNameFocusNode);
                },
                capitalization: TextCapitalization.words,
                enabled: true,
                obscureText: false,
              ),
              LoginTextField(
                controller: lastNameTextController,
                hintText: 'Last name',
                labelText: 'Last name',
                inputType: TextInputType.text,
                height: 64.0,
                inputTypeError: 'Last name is required',
                onTextInputChanged: (lastNameText) => pageState.onLastNameChanged(lastNameText),
                onEditingCompleted: null,
                keyboardAction: TextInputAction.next,
                focusNode: lastNameFocusNode,
                onFocusAction: () {
                  lastNameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(businessNameFocusNode);
                },
                capitalization: TextCapitalization.words,
                enabled: true,
                obscureText: false,
              ),
              LoginTextField(
                controller: businessNameTextController,
                hintText: 'Business name',
                labelText: 'Business name',
                inputType: TextInputType.text,
                height: 64.0,
                inputTypeError: 'Business name is required',
                onTextInputChanged: (businessNameText) => pageState.onBusinessNameChanged(businessNameText),
                onEditingCompleted: null,
                keyboardAction: TextInputAction.next,
                focusNode: businessNameFocusNode,
                onFocusAction: () {
                  businessNameFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(emailFocusNode);
                },
                capitalization: TextCapitalization.words,
                enabled: true,
                obscureText: false,
              ),
              LoginTextField(
                controller: emailTextController,
                hintText: 'Email address',
                labelText: 'Email address',
                inputType: TextInputType.emailAddress,
                height: 64.0,
                inputTypeError: 'Email address is required',
                onTextInputChanged: (emailNameText) => pageState.onEmailAddressNameChanged(emailNameText),
                onEditingCompleted: null,
                keyboardAction: selectedButton == CREATE_ACCOUNT ? TextInputAction.next : TextInputAction.done,
                focusNode: emailFocusNode,
                onFocusAction: () {
                  emailFocusNode.unfocus();
                  if(selectedButton == CREATE_ACCOUNT) {
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  }
                },
                capitalization: TextCapitalization.none,
                enabled: true,
                obscureText: false,
              ),
              selectedButton == CREATE_ACCOUNT ? LoginTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  labelText: 'Password',
                  inputType: TextInputType.visiblePassword,
                  height: 64.0,                 inputTypeError: 'Password name is required',
                  onTextInputChanged: (password) => pageState.onPasswordChanged(password),
                  onEditingCompleted: null,
                  keyboardAction: TextInputAction.done,
                  focusNode: passwordFocusNode,
                  onFocusAction: null,
                  capitalization: TextCapitalization.none,
                  enabled: true,
                  obscureText: true,
              ) : SizedBox(),
          Container(
            margin: EdgeInsets.only(bottom: 256.0),
            child: selectedButton == CREATE_ACCOUNT ? ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controllerErrorShake,
                      curve: new Interval(
                        0.0,
                        0.5,
                        curve: Curves.elasticOut,
                      ),
                    ),
                  ),
                  child: Container(
                margin: EdgeInsets.only(top: 8.0, left: 42.0, right: 42.0, bottom: 128.0),
                child: Text(
                  'Error: ' + (pageState.createAccountErrorMessage.isNotEmpty ? pageState.createAccountErrorMessage : 'Password must be at least 8 characters long, include one upper case and one lower case letter, one number, and one special character.'),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(pageState.createAccountErrorMessage.isNotEmpty ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
              ) : SizedBox()),
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  void _onBackPressed(LoginPageState pageState) {
    selectedButton = null;
    _controllerCreateAccount.reverse();
    _controllerLogoOut.reverse();
    _controller.forward();
    pageState.onClearErrorMessages();
    if(pageState.emailAddress.isNotEmpty)loginEmailTextController.text = pageState.emailAddress;
    if(pageState.password.isNotEmpty)loginPasswordTextController.text = pageState.password;
  }
}
