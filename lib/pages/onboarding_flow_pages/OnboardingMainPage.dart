import 'dart:ui';
import 'package:dandylight/pages/onboarding_flow_pages/OnboardingFlowPageState.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/services.dart';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import 'OnBoardingFlowPageActions.dart';

class OnBoardingMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingMainPageState();
  }
}

class _OnBoardingMainPageState extends State<OnBoardingMainPage>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingFlowPageState>(
      onInit: (appState) {
        appState.dispatch(LoadSettingsFromProfileOnBoarding(appState.state.onBoardingFlowPageState));
      },
      converter: (Store<AppState> store) =>
          OnBoardingFlowPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingFlowPageState pageState) =>
          Scaffold(
            extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorConstants.getBlueLight()),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: 130.0,
              width:  260.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(130.0), bottomRight: Radius.circular(130.0)),
                color: Color(ColorConstants.getPrimaryColor()),
              ),
            ),
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(
                        ColorConstants.getPrimaryWhite()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  centerTitle: true,
                  elevation: 0.0,
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 24.0),
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 34.0),
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
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
                                margin: EdgeInsets.only(top: 124.0, left: 24, right: 24),
                                child: Text(
                                  'Before we get started, lets setup some important items to help save you time and money.',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        ColorConstants.getBlueDark()),
                                  ),
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 114.0),
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
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16.0, top: 64.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Color(ColorConstants.getPrimaryWhite())
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
                              child: Container(
                                height: 54.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 16.0, left: 0.0),
                                          height: 36.0,
                                          width: 36.0,
                                          child: Image.asset('assets/images/icons/briefcase_icon_peach_dark.png', color: Color(ColorConstants.getPeachDark())),
                                        ),
                                        Container(
                                          child: Text(
                                            'Your Job Types',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getBlueDark()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Text(
                                        '( 4 min )',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w700,
                                          color: Color(ColorConstants.primary_bg_grey_dark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0),
                              child: Container(
                                height: 54.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(

                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 16.0, left: 0.0),
                                          height: 36.0,
                                          width: 36.0,
                                          child: Image.asset('assets/images/icons/price_package_black.png', color: Color(ColorConstants.getPeachDark())),
                                        ),
                                        Container(
                                          child: Text(
                                            'Your Price Packages',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getBlueDark()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Text(
                                        '( 3 min )',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w700,
                                          color: Color(ColorConstants.primary_bg_grey_dark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0),
                              child: Container(
                                height: 54.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(right: 16.0, left: 0.0),
                                          height: 36.0,
                                          width: 36.0,
                                          child: Image.asset('assets/images/icons/permission_icon.png', color: Color(ColorConstants.getPeachDark())),
                                        ),
                                        Container(
                                          child: Text(
                                            'App Permissions',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getBlueDark()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Text(
                                        '( 1 min )',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w700,
                                          color: Color(ColorConstants.primary_bg_grey_dark),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 48.0, right: 16.0),
              alignment: Alignment.topRight,
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  pageState.onSkipAllSelected();
                  if(pageState.termsAndPrivacyChecked) {
                    NavigationUtil.onSuccessfulLogin(context);
                  }
                },
                child: Container(
                  child: Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 96.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Text(
                      'By checking the box you agree to our',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'simple',
                        fontWeight: pageState.showTermsAndPrivacyError ? FontWeight.w700 : FontWeight.w600,
                        color: Color(pageState.showTermsAndPrivacyError ? ColorConstants.error_red : ColorConstants.getBlueDark()),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          _launchTermsOfServiceURL();
                        },
                        child: Container(
                          child: Text(
                            'Terms of service',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'simple',
                              fontWeight: pageState.showTermsAndPrivacyError ? FontWeight.w700 : FontWeight.w600,
                              color: Color(pageState.showTermsAndPrivacyError ? ColorConstants.error_red : ColorConstants.getBlueDark()),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' && ',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'simple',
                          fontWeight: pageState.showTermsAndPrivacyError ? FontWeight.w700 : FontWeight.w600,
                          color: Color(pageState.showTermsAndPrivacyError ? ColorConstants.error_red : ColorConstants.getBlueDark()),
                        ),
                      ),
                      TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          _launchPrivacyPolicyURL();
                        },
                        child: Container(
                          child: Text(
                            'Privacy policy',
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'simple',
                              fontWeight: pageState.showTermsAndPrivacyError ? FontWeight.w700 : FontWeight.w600,
                              color: Color(pageState.showTermsAndPrivacyError ? ColorConstants.error_red : ColorConstants.getBlueDark()),
                            ),
                          ),
                        ),
                      ),
                      Checkbox(
                          activeColor: Color(ColorConstants.getBlueDark()),
                          value: pageState.termsAndPrivacyChecked,
                          onChanged: (isChecked) {
                            pageState.onTermsAndPrivacyChecked(isChecked);
                          }
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 32.0),
              padding: EdgeInsets.only(top: 0.0),
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  pageState.onLetsGetStartedSelected();
                  if(pageState.termsAndPrivacyChecked) {
                    NavigationUtil.onLetsGetStartedSelected(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 214,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  height: 54.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.0),
                      color: Color(ColorConstants.getBlueDark())),
                  child: Text(
                    'Let\'s get started!',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(
                          ColorConstants.getPrimaryWhite()),
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

  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
}
