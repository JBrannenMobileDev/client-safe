import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:dandylight/widgets/bouncing_loading_animation/LoginLoadingWidget.dart';
import 'package:flutter/services.dart';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/LoginTextField.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/widgets/login_animations/TranslationImage.dart';
import 'package:dandylight/widgets/login_animations/TranslationWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/DeviceType.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'BusinessAnalyticsInfo.dart';
import 'FreeTrialInfo.dart';
import 'InfoContainerWidget.dart';
import 'InvoiceInfo.dart';
import 'JobTrackingInfo.dart';
import 'IncomeAndExpensesInfo.dart';
import 'StayOrganizedInfo.dart';
import 'TrackYourMilesInfo.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // static const String SIGN_IN_WITH_GOOGLE = 'Sign in with Google';
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

  final int pageCount = 7;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  bool obscureText = true;

  @override
  void initState() {
    super.initState();

    currentPageIndex = 0;

    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });

    // final duration = Duration(seconds: 8);
    // Timer.periodic(duration, (timer) {
    //   // Stop the timer when it matches a condition
    //   if (controller.hasClients && currentPageIndex < pageCount - 1) {
    //     currentPageIndex = currentPageIndex + 1;
    //     controller.animateToPage(currentPageIndex, duration: Duration(milliseconds: 350), curve: Curves.ease);
    //   } else {
    //     currentPageIndex = 0;
    //     if(controller.hasClients) controller.animateToPage(currentPageIndex, duration: Duration(milliseconds: 150), curve: Curves.ease);
    //   }
    // });

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

    EventSender().sendEvent(eventName: EventNames.APP_OPENED);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
        onWillChange: (previous, current) {
          if(current.isCurrentUserCheckComplete && !current.navigateToHome && selectedButton != CREATE_ACCOUNT) {
            _controller.forward();
            _controllerLogoIn.forward();
            _controllerSunIn.forward();
            _controllerLoginErrorShake.forward();
          }
          if(current.mainButtonsVisible != previous.mainButtonsVisible){
            if(previous.mainButtonsVisible){
              _controllerLoginView.forward();
            }else {
              _controllerLoginView.reverse();
            }
          }
        },
        onDidChange: (prev, pageState) {
          if(pageState.navigateToHome) {
            _onStartAnimationForGoingToHomePage(pageState);
          }
          if(pageState.shouldShowOnBoardingFlow) {
            _onStartAnimationForGoingToOnBoardingPage(pageState);
          }
          if(pageState.createAccountErrorMessage.isNotEmpty){
            _controllerErrorShake.reset();
            _controllerErrorShake.forward();
          }
          if(!prev.shouldShowAccountCreatedDialog && pageState.shouldShowAccountCreatedDialog){
            pageState.user.sendEmailVerification();
            UserOptionsUtil.showAccountCreatedDialog(context, pageState.user);
            pageState.resetShouldShowSuccessDialog();
            _onBackPressed(pageState);
          }
          if(pageState.shouldShowResetPasswordSentDialog) {
            UserOptionsUtil.showResetPasswordEmailSentDialog(context, pageState.user);
            pageState.resetShouldShowResetPasswordSentDialog();
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(ColorConstants.getBlueLight()),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              // TranslationImage(
              //   image: AssetImage(ImageUtil.LOGIN_BG_BLUE_MOUNTAIN),
              //   controller: _controller,
              //   animations: [
              //     darkBlueMountainsStep3,
              //   ],
              // ),
              // TranslationImage(
              //   image: AssetImage(ImageUtil.LOGIN_BG_PEACH_DARK_MOUNTAIN),
              //   controller: _controller,
              //   animations: [
              //     peachDarkMountainsStep2,
              //   ],
              // ),
              // TranslationImage(
              //   image: AssetImage(ImageUtil.LOGIN_BG_PEACH_MOUNTAIN),
              //   controller: _controller,
              //   animations: [
              //     lightPeachMountainsStep1,
              //   ],
              // ),
              !pageState.isUserVerified  && selectedButton == null ? Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/backgrounds/login_bg.jpg'),
                          fit: BoxFit.cover,
                      )
                  ),
              ) : SizedBox(),
              !pageState.isUserVerified ? SlideTransition(
                position: lightPeachMountainsStep1,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(bottom: 24.0, top: 232),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          // SlideTransition(
                          //   position: hideMainButtonsStep,
                          //   child: Container(
                          //     height: 264.0,
                          //     width: MediaQuery.of(context).size.width,
                          //     child: PageView(
                          //       controller: controller,
                          //       pageSnapping: true,
                          //       children: <Widget>[
                          //         InfoContainerWidget(contentWidget: FreeTrialInfo(),),
                          //         InfoContainerWidget(contentWidget: JobTrackingInfo(),),
                          //         InfoContainerWidget(contentWidget: TrackYourMilesInfo(),),
                          //         InfoContainerWidget(contentWidget: IncomeAndExpensesInfo(),),
                          //         InfoContainerWidget(contentWidget: InvoiceInfo(),),
                          //         InfoContainerWidget(contentWidget: StayOrganizedInfo(),),
                          //         InfoContainerWidget(contentWidget: BusinessAnalyticsInfo(),),
                          //       ],
                          //       onPageChanged: (index) {
                          //         setState(() {
                          //           currentPageIndex = index;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // DeviceType.getDeviceType() == Type.Tablet && !pageState.mainButtonsVisible ? SizedBox() : SlideTransition(
                          //   position: hideMainButtonsStep,
                          //   child: Container(
                          //     margin: EdgeInsets.only(bottom: 16.0),
                          //     alignment: Alignment.center,
                          //     width: 250,
                          //     child: AnimatedSmoothIndicator(
                          //       activeIndex: currentPageIndex,
                          //       count: 7,
                          //       effect: ExpandingDotsEffect(
                          //           expansionFactor: 2,
                          //           dotWidth: 8.0,
                          //           dotHeight: 8.0,
                          //           activeDotColor: Color(ColorConstants.getPeachDark()),
                          //           dotColor: Color(ColorConstants.getPrimaryWhite())),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DeviceType.getDeviceType() == Type.Tablet && !pageState.mainButtonsVisible ? SizedBox() : SlideTransition(
                          position: hideMainButtonsStep,
                          child: Platform.isIOS && pageState.isLoginWithAppleAvailable ? GestureDetector(
                            onTap: () {
                              pageState.onSignUpWithAppleSelected();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              alignment: Alignment.centerLeft,
                              height: 48.0,
                              width: 232.0,
                              decoration: BoxDecoration(
                                  color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(36.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 16.0),
                                    height: 20.0,
                                    width: 20.0,
                                    child: Image.asset(
                                      'assets/images/icons/apple-logo.png',
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                  TextDandyLight(
                                    text: 'Sign up with Apple',
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  )
                                ],
                              ),
                            ),
                          ) : SizedBox(),
                        ),
                        // DeviceType.getDeviceType() == Type.Tablet && !pageState.mainButtonsVisible ? SizedBox() : SlideTransition(
                        //   position: hideMainButtonsStep,
                        //   child: Platform.isAndroid ? GestureDetector(
                        //     onTap: () {
                        //       pageState.onSignUpWithGoogleSelected();
                        //     },
                        //     child: Container(
                        //       padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        //       alignment: Alignment.centerLeft,
                        //       height: 48.0,
                        //       width: 232,
                        //       decoration: BoxDecoration(
                        //           color: Color(ColorConstants.getPrimaryWhite()),
                        //           borderRadius: BorderRadius.circular(36.0)),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: <Widget>[
                        //           Container(
                        //             margin: EdgeInsets.only(right: 16.0),
                        //             height: 22.0,
                        //             width: 22.0,
                        //             child: Image.asset(
                        //               'assets/images/icons/google.png',
                        //               color: Color(ColorConstants.getPeachDark()),
                        //             ),
                        //           ),
                        //           TextDandyLight(
                        //             text: 'Sign up with Google',
                        //             type: TextDandyLight.MEDIUM_TEXT,
                        //             color: Color(ColorConstants.getPeachDark()),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ) : SizedBox(),
                        // ),
                        DeviceType.getDeviceType() == Type.Tablet && !pageState.mainButtonsVisible ? SizedBox() : SlideTransition(
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
                              EventSender().sendEvent(eventName: EventNames.BT_START_FREE_TRIAL);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 16.0),
                              alignment: Alignment.center,
                              height: 48.0,
                              width: 232.0,
                              decoration: BoxDecoration(
                                  color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(36.0)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 16.0),
                                    height: 22.0,
                                    width: 22.0,
                                    child: Image.asset(
                                      'assets/images/icons/envelope.png',
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                  TextDandyLight(
                                    text: 'Sign up with email',
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              if(pageState.mainButtonsVisible){
                                pageState.updateMainButtonVisible(false);
                              }else if(pageState.isForgotPasswordViewVisible){
                                pageState.updateForgotPasswordVisible(false);
                              }else {
                                pageState.updateMainButtonVisible(true);
                              }
                              pageState.onClearErrorMessages();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.mainButtonsVisible ? 'Sign in' : (pageState.isForgotPasswordViewVisible ? 'Sign in' : 'Create Account'),
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                        (pageState.isForgotPasswordViewVisible || pageState.mainButtonsVisible) ? SizedBox(height: 38.0,) : Container(
                          margin: EdgeInsets.only(top: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              pageState.updateForgotPasswordVisible(true);
                              pageState.onClearErrorMessages();
                              EventSender().sendEvent(eventName: EventNames.BT_FORGOT_PASSWORD);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Forgot password ?',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        )
                      ],
                    ),
                    ],
                  ),
                ),
              ) : SizedBox(),
          !pageState.isUserVerified ? (pageState.showResendMessage && !pageState.mainButtonsVisible) ? SlideTransition(
            position: lightPeachMountainsStep1,
            child:Container(
                height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 416.0),
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
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Verification is incomplete.',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            GestureDetector(
                              onTap: () {
                                pageState.onResendEmailVerificationSelected();
                                EventSender().sendEvent(eventName: EventNames.BT_RESEND_VERIFICATION_EMAIL);
                              },
                              child: Container(
                                height: 32.0,
                                width: 88.0,
                                margin: EdgeInsets.only(left: 8.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getBlueDark()),
                                    borderRadius: BorderRadius.circular(24.0)),
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: 'Resend',
                                  color: Color(ColorConstants.getPrimaryWhite()),
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
                  width: 424,
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(bottom: 90.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SlideTransition(
                        position: showLoginButtonsStep,
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: pageState.loginErrorMessage,
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.error_red),
                        ),
                      ),
                      DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible || pageState.showLoginLoadingAnimation ? SizedBox() : Platform.isIOS && pageState.isLoginWithAppleAvailable ? SlideTransition(
                          position: showLoginButtonsStep,
                          child: GestureDetector(
                        onTap: () {
                          pageState.onSignUpWithAppleSelected();
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 8.0),
                          alignment: Alignment.centerLeft,
                          height: 54.0,
                          decoration: BoxDecoration(
                              color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(36.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 16.0),
                                height: 18.0,
                                width: 18.0,
                                child: Image.asset(
                                  'assets/images/icons/apple-logo.png',
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                              TextDandyLight(
                                text: 'Sign in with Apple',
                                type: TextDandyLight.LARGE_TEXT,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              )
                            ],
                          ),
                        ),
                      )) : SizedBox(),

                    //   DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible || pageState.showLoginLoadingAnimation ? SizedBox() : Platform.isAndroid ? SlideTransition(
                    //       position: showLoginButtonsStep,
                    //       child: GestureDetector(
                    //     onTap: () {
                    //       pageState.onSignUpWithGoogleSelected();
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    //       margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 8.0),
                    //       alignment: Alignment.centerLeft,
                    //       height: 54.0,
                    //       decoration: BoxDecoration(
                    //           color: Color(ColorConstants.getPrimaryWhite()),
                    //           borderRadius: BorderRadius.circular(36.0)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: <Widget>[
                    //           Container(
                    //             margin: EdgeInsets.only(right: 16.0),
                    //             height: 24.0,
                    //             width: 24.0,
                    //             child: Image.asset(
                    //               'assets/images/icons/google.png',
                    //             ),
                    //           ),
                    //           TextDandyLight(
                    //             text: 'Sign in with Google',
                    //             type: TextDandyLight.LARGE_TEXT,
                    //             color: Color(ColorConstants.getPrimaryBlack()),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ) : SizedBox(),

                    DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible || pageState.showLoginLoadingAnimation || Platform.isAndroid ? SizedBox() : SlideTransition(
                    position: showLoginButtonsStep,
                    child: Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(

                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 48.0, right: 8),
                                height: 1,
                                width: double.infinity,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Or',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8, right: 48),
                                height: 1,
                                width: double.infinity,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            )
                          ],
                        ),
                      ),
                  ),
                      DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible || pageState.showLoginLoadingAnimation ? SizedBox() : SlideTransition(
                        position: showLoginButtonsStep,
                        child: LoginTextField(
                          maxLines: 1,
                          controller: loginEmailTextController,
                          hintText: 'Email address',
                          labelText: 'Email address',
                          inputType: TextInputType.emailAddress,
                          height: 54.0,
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
                      ),
                      DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible || pageState.showLoginLoadingAnimation || pageState.isForgotPasswordViewVisible ? SizedBox() : SlideTransition(
                        position: showLoginButtonsStep,
                        child: LoginTextField(
                          maxLines: 1,
                          controller: loginPasswordTextController,
                          hintText: 'Password',
                          labelText: 'Password',
                          inputType: TextInputType.text,
                          height: 54.0,
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
                      ),
                      DeviceType.getDeviceType() == Type.Tablet && pageState.mainButtonsVisible ? SizedBox() : SlideTransition(
                        position: showLoginButtonsStep,
                        child: GestureDetector(
                          onTap: () {
                            if(!pageState.showLoginLoadingAnimation && !pageState.isForgotPasswordViewVisible) {
                              pageState.onLoginSelected();
                              EventSender().sendEvent(eventName: EventNames.BT_SIGN_IN);
                            } else if(pageState.isForgotPasswordViewVisible) {
                              pageState.onResetPasswordSelected();
                              pageState.updateForgotPasswordVisible(false);
                              EventSender().sendEvent(eventName: EventNames.BT_RESET_PASSWORD);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 32, right: 32, bottom: 6.0, top: 8),
                            alignment: Alignment.center,
                            height: 54.0,
                            decoration: !pageState.showLoginLoadingAnimation ? BoxDecoration(
                                color: Color(ColorConstants.getBlueDark()),
                                borderRadius: BorderRadius.circular(36.0)) : BoxDecoration(),
                            child: pageState.showLoginLoadingAnimation
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Signing In',
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: LoadingAnimationWidget.fourRotatingDots(
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    size: 26,
                                  ),
                                ),
                              ],
                            ) : pageState.isForgotPasswordViewVisible ? TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Reset Password',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ) : TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              text: 'Sign in',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryWhite()),
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
                          child: selectedButton != CREATE_ACCOUNT ? Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              DeviceType.getDeviceType() == Type.Phone ? Container(
                                margin: EdgeInsets.only(top: 124),
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
                                    pageState.mainButtonsVisible == true ? 'DandyLight' : '',
                                  ),
                                ),
                              ) : Container(
                                margin: EdgeInsets.only(top: 78),
                                child: AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 204,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants
                                        .getPrimaryWhite())
                                        .withOpacity(1.0),
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                  child: Text(
                                    pageState.mainButtonsVisible == true ? 'DandyLight' : '',
                                  ),
                                ),
                              ),
                              pageState.mainButtonsVisible == true ? DeviceType.getDeviceType() == Type.Phone ? Container(
                                margin: EdgeInsets.only(
                                    bottom: 230.0, left: 114.0, top: 88.0),
                                height: 150.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        ImageUtil.LOGIN_BG_LOGO_FLOWER),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ) : Container(
                                margin: EdgeInsets.only(
                                    bottom: 230.0, left: 229.0, top: 60.0),
                                height: 300.0,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        ImageUtil.LOGIN_BG_LOGO_FLOWER),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ) : SizedBox(),
                              pageState.mainButtonsVisible == true ? selectedButton != CREATE_ACCOUNT ? DeviceType.getDeviceType() == Type.Phone ? Container(
                                  width: 232.0,
                                  margin: EdgeInsets.only(top: 213.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Capture the moment We\'ll do the rest',
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  )
                              ) : Container(
                                  width: 350.0,
                                  margin: EdgeInsets.only(top: 324.0),
                                  child: TextDandyLight(
                                    type: TextDandyLight.EXTRA_LARGE_TEXT,
                                    text: 'Capture the moment We\'ll do the rest',
                                    textAlign: TextAlign.center,
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                  )
                              ) : SizedBox() : SizedBox(),
                            ],
                          ) : SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              selectedButton != null ? SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 12.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: selectedButton,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ) : SizedBox(),
              _getCreateAccountTextFieldWidgets(selectedButton, pageState),
              selectedButton == CREATE_ACCOUNT ? SafeArea(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      pageState.onCreateAccountSubmitted();
                      EventSender().sendEvent(eventName: EventNames.BT_SUBMIT_CREATE_ACCOUNT);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0, left: 32.0, right: 32.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPeachDark()),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: pageState.showCreateAccountLoadingAnimation
                          ? Center(child: LoginLoadingWidget())
                          : TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Submit',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(),
              // selectedButton == SIGN_IN_WITH_GOOGLE ? SafeArea(
              //   child: Container(
              //     alignment: Alignment.bottomCenter,
              //     child: GestureDetector(
              //       onTap: () {
              //         pageState.onContinueWithGoogleSubmitted();
              //       },
              //       child: Container(
              //         margin: EdgeInsets.only(top: 8.0, left: 64.0, right: 64.0),
              //         alignment: Alignment.center,
              //         height: 64.0,
              //         decoration: BoxDecoration(
              //             color: Color(ColorConstants.getPeachDark()),
              //             borderRadius: BorderRadius.circular(32.0)),
              //         child: TextDandyLight(
              //           type: TextDandyLight.LARGE_TEXT,
              //           text: 'Sign in with Google',
              //           textAlign: TextAlign.center,
              //           color: Color(ColorConstants.getPrimaryWhite()),
              //         ),
              //       ),
              //     ),
              //   ),
              // ) : SizedBox(),
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
              !pageState.isCurrentUserCheckComplete && !pageState.navigateToHome ? Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getBlueLight()),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/backgrounds/flowerBgLaunch.png"),
                    ),
                  ),
                ),
              ) : SizedBox(),
              pageState.showLoadingAnimation ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(ColorConstants.getBlueLight()),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/backgrounds/flowerBgLaunch.png"),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox()
            ],
          ),
        ),
      );
  }

  void _onStartAnimationForGoingToHomePage(LoginPageState pageState){
    if(pageState.mainButtonsVisible) {
      _controller.reverse();
      _controllerLogoOut.forward();
      _controllerSunIn.reverse();
      Timer(const Duration(milliseconds: 600), () {
        NavigationUtil.onSuccessfulLogin(context);
      });
    } else {
      NavigationUtil.onSuccessfulLogin(context);
    }
  }

  void _onStartAnimationForGoingToOnBoardingPage(LoginPageState pageState){
    if(pageState.mainButtonsVisible) {
      _controller.reverse();
      _controllerLogoOut.forward();
      _controllerSunIn.reverse();
      Timer(const Duration(milliseconds: 600), () {
        NavigationUtil.onShowOnBoarding(context);
      });
    } else {
      NavigationUtil.onShowOnBoarding(context);
    }
  }

  Widget _getCreateAccountTextFieldWidgets(String selectedButton, LoginPageState pageState) {
    if(selectedButton != null) {
      return SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 64.0),
          child: ListView(
            children: <Widget>[
              LoginTextField(
                maxLines: 1,
                controller: firstNameTextController,
                hintText: 'First name',
                labelText: 'First name',
                inputType: TextInputType.text,
                height: 54.0,
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
                maxLines: 1,
                controller: lastNameTextController,
                hintText: 'Last name',
                labelText: 'Last name',
                inputType: TextInputType.text,
                height: 54.0,
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
                maxLines: 1,
                controller: businessNameTextController,
                hintText: 'Business name',
                labelText: 'Business name',
                inputType: TextInputType.text,
                height: 54.0,
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
                maxLines: 1,
                controller: emailTextController,
                hintText: 'Email address',
                labelText: 'Email address',
                inputType: TextInputType.emailAddress,
                height: 54.0,
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
              selectedButton == CREATE_ACCOUNT ? Stack(
                children: [
                  LoginTextField(
                    maxLines: 1,
                    controller: passwordTextController,
                    hintText: 'Password',
                    labelText: 'Password',
                    inputType: TextInputType.visiblePassword,
                    height: 54.0,                 inputTypeError: 'Password name is required',
                    onTextInputChanged: (password) => pageState.onPasswordChanged(password),
                    onEditingCompleted: null,
                    keyboardAction: TextInputAction.done,
                    focusNode: passwordFocusNode,
                    onFocusAction: null,
                    capitalization: TextCapitalization.none,
                    enabled: true,
                    obscureText: obscureText,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 42),
                    height: 70,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Color(ColorConstants.getPeachDark()),),
                    ),
                  ),
                ],
              ) : SizedBox(),
              Container(
                width: 148.0,
                margin: EdgeInsets.only(top: 32.0, left: 32, right: 32),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Try for free',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
              Container(
                width: 148.0,
                margin: EdgeInsets.only(top: 4.0, left: 32, right: 32),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'No credit card required',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            Container(
                width: 175.0,
                margin: EdgeInsets.only(top: 32.0, left: 32, right: 32, bottom: 16),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Creating an account will start your free trial. You will not be charged automatically. Once you reach your 3 job limit, a subscription will be required to gain access to unlimited jobs.',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Platform.isIOS ? TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      _launchAppleEULA();
                    },
                    child: Container(
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Terms of Use',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ) : TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      _launchTermsOfServiceURL();
                    },
                    child: Container(
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Terms of service',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      _launchPrivacyPolicyURL();
                    },
                    child: Container(
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Privacy Policy',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              ),
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
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Error: ' + (pageState.createAccountErrorMessage.isNotEmpty ? pageState.createAccountErrorMessage : 'Password must be at least 8 characters long, include one upper case and one lower case letter, one number, and one special character.'),
                  textAlign: TextAlign.start,
                  color: Color(pageState.createAccountErrorMessage.isNotEmpty ? ColorConstants.error_red : ColorConstants.getPrimaryWhite()),
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

  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
  void _launchAppleEULA() async => await canLaunchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) ? await launchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')) : throw 'Could not launch';
}
