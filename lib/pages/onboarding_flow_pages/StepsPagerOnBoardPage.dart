import 'dart:ui';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnboardingFlowPageState.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/services.dart';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/KeyboardUtil.dart';
import 'OnBoardingFlowPageActions.dart';

class StepsPagerOnBoardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StepsPagerOnBoardPageState();
  }
}

class _StepsPagerOnBoardPageState extends State<StepsPagerOnBoardPage>
    with TickerProviderStateMixin {
  final int pageCount = 3;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, OnBoardingFlowPageState>(
      onInit: (appState) {
        appState.dispatch(LoadSettingsFromProfileOnBoarding(
            appState.state.onBoardingFlowPageState));
      },
      converter: (Store<AppState> store) =>
          OnBoardingFlowPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingFlowPageState pageState) =>
    WillPopScope(
    onWillPop: () async {
      if (currentPageIndex == 0) {
        Navigator.of(context).pop();
      } else {
        pageState.onBackSelected();
        controller.animateToPage(currentPageIndex - 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
      }
      return false;
    },
    child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(ColorConstants
                        .getPrimaryBlack()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                  pinned: true,
                  centerTitle: true,
                  title: Text(
                    pageState.pagerIndex == 0
                        ? 'Job Types'
                        : pageState.pagerIndex == 1
                            ? 'Price Packages'
                            : pageState.pagerIndex == 2
                                ? 'Payment Links'
                                : 'App Permissions',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        height: 300.0,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          pageSnapping: true,
                          children: <Widget>[
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 64.0, right: 16.0),
              alignment: Alignment.topRight,
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  pageState.onSkipAllSelected();
                  if (pageState.termsAndPrivacyChecked) {
                    NavigationUtil.onSuccessfulLogin(context);
                  }
                },
                child: Container(
                  child: Text(
                    'Skip',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 54.0),
              child: AnimatedSmoothIndicator(
                activeIndex: pageState.pagerIndex,
                count: 4,
                effect: ExpandingDotsEffect(
                    dotWidth: 12.0,
                    dotHeight: 12.0,
                    activeDotColor: Color(ColorConstants.getPrimaryColor()),
                    dotColor: Color(ColorConstants.getPrimaryColor())),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 32.0),
              padding: EdgeInsets.only(top: 8.0),
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  if (currentPageIndex == 3) {
                    pageState.onBoardingComplete();
                    NavigationUtil.onSuccessfulLogin(context);
                  } else {
                    pageState.onNextSelected();
                    controller.animateToPage(currentPageIndex + 1,
                        duration: Duration(milliseconds: 150),
                        curve: Curves.ease);
                  }
                  if (MediaQuery.of(context).viewInsets.bottom != 0)
                    KeyboardUtil.closeKeyboard(context);
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
                    pageState.pagerIndex == 3 ? 'Finish' : 'Next',
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
      ),
    ),
    );
  }

  Future<bool> _onWillPop() async {
    if (currentPageIndex == 0) {
      Navigator.of(context).pop();
    } else {
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
    return false;
  }

  void onBackPressed(OnBoardingFlowPageState pageState) {}
}
