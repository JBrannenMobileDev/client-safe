import 'package:dandylight/pages/new_job_types_page/DandyLightTextField.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/analytics/EventNames.dart';
import '../../widgets/TextDandyLight.dart';

class WhatTypePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _WhatTypePage();
  }
}

class _WhatTypePage extends State<WhatTypePage> {
  final otherController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
          Container(
            margin: const EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 0),
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
                        text: "How many jobs do you book in a month?",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedJobCount == OnBoardingPageState.LESS_THAN_5 ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile<String>(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: OnBoardingPageState.LESS_THAN_5,
                          textAlign: TextAlign.start,
                        ),
                        value: pageState.selectedJobCount!,
                        groupValue: OnBoardingPageState.LESS_THAN_5,
                        onChanged: (value){
                          pageState.onJobCountSelected!(OnBoardingPageState.LESS_THAN_5);
                        },
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedJobCount == OnBoardingPageState.BETWEEN_5_15 ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile<String>(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: OnBoardingPageState.BETWEEN_5_15,
                          textAlign: TextAlign.start,
                        ),
                        value: pageState.selectedJobCount!,
                        groupValue: OnBoardingPageState.BETWEEN_5_15,
                        onChanged: (value){
                          pageState.onJobCountSelected!(OnBoardingPageState.BETWEEN_5_15);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.selectedJobCount == OnBoardingPageState.MORE_THAN_15 ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: RadioListTile<String>(
                        activeColor: Color(ColorConstants.getPeachDark()),
                        title: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: OnBoardingPageState.MORE_THAN_15,
                          textAlign: TextAlign.start,
                        ),
                        value: pageState.selectedJobCount!,
                        groupValue: OnBoardingPageState.MORE_THAN_15,
                        onChanged: (value){
                          pageState.onJobCountSelected!(OnBoardingPageState.MORE_THAN_15);
                        },
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if(pageState.typeContinueEnable!) {
                      EventSender().sendEvent(
                          eventName: EventNames.ON_BOARDING_JOB_COUNT_SELECTED,
                          properties: {EventNames.ON_BOARDING_JOB_COUNT_PARAM : pageState.selectedJobCount!}
                      );
                      EventSender().setUserProfileData('Photographer type', pageState.selectedJobCount!);
                      pageState.setPagerIndex!(1);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: const EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(pageState.typeContinueEnable! ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                        borderRadius: BorderRadius.circular(36.0)),
                    child: TextDandyLight(
                      text: 'Continue',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(pageState.typeContinueEnable! ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
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
