import 'package:dandylight/pages/new_job_types_page/DandyLightTextField.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';

class ZoomCallSelectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ZoomCallSelectionPage();
  }
}

class _ZoomCallSelectionPage extends State<ZoomCallSelectionPage> {
  final otherController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  bool hasClickedBook = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 0, top: 54, right: 0, bottom: 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 32, right: 32),
                      child: TextDandyLight(
                        textAlign: TextAlign.center,
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "Please select a Zoom call option",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedZoomOption == OnBoardingPageState.APP_WALKTHROUGH ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: OnBoardingPageState.APP_WALKTHROUGH,
                          textAlign: TextAlign.start,
                        ),
                        value: pageState.selectedZoomOption,
                        groupValue: OnBoardingPageState.APP_WALKTHROUGH,
                        onChanged: (value){
                          pageState.onZoomOptionSelected(OnBoardingPageState.APP_WALKTHROUGH);
                        },
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedZoomOption == OnBoardingPageState.FIRST_TIME_SETUP ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: OnBoardingPageState.FIRST_TIME_SETUP,
                          textAlign: TextAlign.start,
                        ),
                        value: pageState.selectedZoomOption,
                        groupValue: OnBoardingPageState.FIRST_TIME_SETUP,
                        onChanged: (value){
                          pageState.onZoomOptionSelected(OnBoardingPageState.FIRST_TIME_SETUP);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 32.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedZoomOption == OnBoardingPageState.NEW_USER_SURVEY ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: OnBoardingPageState.NEW_USER_SURVEY,
                              textAlign: TextAlign.start,
                            ),
                            TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Get 3 months free!',
                                textAlign: TextAlign.start,
                                isBold: true,
                            )
                          ],
                        ),
                        value: pageState.selectedZoomOption,
                        groupValue: OnBoardingPageState.NEW_USER_SURVEY,
                        onChanged: (value){
                          pageState.onZoomOptionSelected(OnBoardingPageState.NEW_USER_SURVEY);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        switch(pageState.selectedZoomOption) {
                          case OnBoardingPageState.APP_WALKTHROUGH:
                            IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/app-walkthrough');
                            break;
                          case OnBoardingPageState.FIRST_TIME_SETUP:
                            IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/first-time-setup');
                            break;
                          case OnBoardingPageState.NEW_USER_SURVEY:
                            IntentLauncherUtil.launchURLInternalBrowser('https://calendly.com/dandylight/15-min-survey');
                            break;
                        }
                        setState(() {
                          hasClickedBook = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                        alignment: Alignment.center,
                        height: 54.0,
                        decoration: BoxDecoration(
                            color: Color(pageState.selectedZoomOption.isNotEmpty ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                            borderRadius: BorderRadius.circular(36.0)),
                        child: TextDandyLight(
                          text: 'Book Zoom Call',
                          type: TextDandyLight.LARGE_TEXT,
                          color: Color(pageState.selectedZoomOption.isNotEmpty ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    pageState.setPagerIndex(4);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(hasClickedBook ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                        borderRadius: BorderRadius.circular(36.0)),
                    child: TextDandyLight(
                      text: pageState.selectedZoomOption.isNotEmpty ? 'Continue' : 'Skip',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(hasClickedBook ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
