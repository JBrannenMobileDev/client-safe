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

class OnBoardingJobTypesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingJobTypesPageState();
  }
}

class _OnBoardingJobTypesPageState extends State<OnBoardingJobTypesPage>
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
          Stack(
            children: [
              pageState.jobTypes.length > 0 ? ListView(

              ) : Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24, top: 16),
                    child: Text(
                      'Let\'s save some time and add your first job type! Select the button below to get started.',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 32.0),
                padding: EdgeInsets.only(top: 8.0),
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {

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
                      'New Job Type',
                      textAlign: TextAlign.start,
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
            ],
          ),
    );
  }

  void _launchPrivacyPolicyURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/9b78efad-d67f-4e08-9e02-035399b830ed')) : throw 'Could not launch';
  void _launchTermsOfServiceURL() async => await canLaunchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) ? await launchUrl(Uri.parse('https://www.privacypolicies.com/live/acaa632a-a22b-490b-87ee-7bd9c94c679e')) : throw 'Could not launch';
}
