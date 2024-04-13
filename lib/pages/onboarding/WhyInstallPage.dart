import 'package:dandylight/pages/new_job_types_page/DandyLightTextField.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/Shadows.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class WhyInstallPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _WhyInstallPage();
  }
}

class _WhyInstallPage extends State<WhyInstallPage> {
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
                      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
                      child: TextDandyLight(
                        textAlign: TextAlign.center,
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "Why did you install Dandylight?",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    checkboxItem(OnBoardingPageState.HAVING_EVERYTHING_IN_ONE_PLACE, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.HAVING_EVERYTHING_IN_ONE_PLACE)),
                    checkboxItem(OnBoardingPageState.LOOK_PROFESSIONAL, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.LOOK_PROFESSIONAL)),
                    checkboxItem(OnBoardingPageState.POSES_FOR_INSPIRATION, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.POSES_FOR_INSPIRATION)),
                    checkboxItem(OnBoardingPageState.CONTRACTS, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.CONTRACTS)),
                    checkboxItem(OnBoardingPageState.INVOICES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.INVOICES)),
                    checkboxItem(OnBoardingPageState.QUESTIONNAIRES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.QUESTIONNAIRES)),
                    checkboxItem(OnBoardingPageState.BOOKING_AND_AVAILABILITY, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.BOOKING_AND_AVAILABILITY)),
                    checkboxItem(OnBoardingPageState.CLIENT_GALLERIES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.CLIENT_GALLERIES)),
                    checkboxItem(OnBoardingPageState.TRACKING_MY_JOBS, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.TRACKING_MY_JOBS)),
                    checkboxItem(OnBoardingPageState.SUN_TRACKER, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.SUN_TRACKER)),
                    checkboxItem(OnBoardingPageState.TRACK_INCOME_AND_EXPENSES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.TRACK_INCOME_AND_EXPENSES)),
                    checkboxItem(OnBoardingPageState.CLIENT_GUIDES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.CLIENT_GUIDES)),
                    checkboxItem(OnBoardingPageState.TRACKING_MILES_FOR_TAXES, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.TRACKING_MILES_FOR_TAXES)),
                    checkboxItem(OnBoardingPageState.OTHER, pageState.onFeatureSelected!, pageState.selectedReasons!.contains(OnBoardingPageState.OTHER)),
                    pageState.selectedReasons!.contains(OnBoardingPageState.OTHER) ? Container(
                      margin: const EdgeInsets.only(bottom: 116, left: 24, right: 24),
                      child: DandyLightTextField(
                        controller: otherController,
                        hintText: 'Write a short description of the problem you are hoping to solve here.',
                        inputType: TextInputType.text,
                        focusNode: null,
                        onFocusAction: null,
                        height: 116.0,
                        maxLength: 500,
                        onTextInputChanged: pageState.onOtherChanged,
                        keyboardAction: TextInputAction.done,
                        capitalization: TextCapitalization.words,
                      ),
                    ) : const SizedBox(),
                    const SizedBox(height: 164),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if(pageState.featuresContinueEnabled!) {
                      for(String reason in pageState.selectedReasons!) {
                        EventSender().sendEvent(eventName: EventNames.ON_BOARDING_PROBLEM_CHOSEN, properties: {
                          EventNames.ON_BOARDING_PROBLEM_CHOSEN_PARAM : reason,
                        });
                      }
                      pageState.setPagerIndex!(3);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: const EdgeInsets.only(left: 48.0, right: 48.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(pageState.featuresContinueEnabled! ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                        borderRadius: BorderRadius.circular(36.0),
                        boxShadow: ElevationToShadow[4],
                    ),
                    child: TextDandyLight(
                      text: 'Continue',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(pageState.featuresContinueEnabled! ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget checkboxItem(String name, Function onSelected, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      margin: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
      alignment: Alignment.center,
      height: 54.0,
      decoration: BoxDecoration(
          color: Color(isSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
          borderRadius: BorderRadius.circular(36.0)),
      child:
      CheckboxListTile(
        title: TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: name,
          textAlign: TextAlign.start,
        ),
        value: isSelected,
        activeColor: Color(ColorConstants.getPeachDark()),
        onChanged: (selected) {
          onSelected(name, selected);
        },
        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
      ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
