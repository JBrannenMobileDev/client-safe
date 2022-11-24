import 'dart:ui';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnBoardingJobTypesPage.dart';
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
  final int pageCount = 2;
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
      if (pageState.pagerIndex == 0) {
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
        backgroundColor: Color(ColorConstants.getBlueLight()),
        body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.getBlueLight()),
                  pinned: true,
                  centerTitle: true,
                  title: Container(
                    child: AnimatedSmoothIndicator(
                      activeIndex: pageState.pagerIndex,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        expansionFactor: 2,
                          dotWidth: 16.0,
                          dotHeight: 16.0,
                          activeDotColor: Color(ColorConstants.getBlueDark()),
                          dotColor: Color(ColorConstants.getPrimaryWhite())),
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(CupertinoIcons.person, size: 30.0,),
                      onPressed: () {
                        pageState.onNextSelected();
                        controller.animateToPage(currentPageIndex + 1,
                            duration: Duration(milliseconds: 150), curve: Curves.ease);
                      },
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size(150, 24),
                    child: Container(
                      child: Text(
                        pageState.pagerIndex == 0
                            ? 'Job Types'
                            : pageState.pagerIndex == 1
                            ? 'Price Packages'
                            : 'App Permissions',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height - 150,
                        child: PageView(
                          controller: controller,
                          pageSnapping: true,
                          children: <Widget>[
                            OnBoardingJobTypesPage(),
                            SizedBox(),
                            SizedBox(),
                          ],
                          onPageChanged: (index) {
                            if(pageState.pagerIndex > index) {
                              currentPageIndex - 1;
                              pageState.onBackSelected();
                            }  else if(pageState.pagerIndex < index){
                              currentPageIndex + 1;
                              pageState.onNextSelected();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
        ),
      ),
    ),
    );
  }
}
