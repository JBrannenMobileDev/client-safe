import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';

class FeatureSelectionPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FeatureSelectionPage();
  }
}

class _FeatureSelectionPage extends State<FeatureSelectionPage> {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnBoardingPageState>(
      onInit: (store) {
        notesController.value = notesController.value.copyWith(text:store.state.jobDetailsPageState.notes);
      },
      converter: (store) => OnBoardingPageState.fromStore(store),
      builder: (BuildContext context, OnBoardingPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "What features of Dandylight are you most interested in?",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 32.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.jobTrackingSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Job Tracking'),
                        value: pageState.jobTrackingSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.incomeExpensesSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Income & Expenses'),
                        value: pageState.incomeExpensesSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.INCOME_EXPENSES, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.posesSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Poses'),
                        value: pageState.posesSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.POSES, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.mileageTrackingSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Mileage Tracking'),
                        value: pageState.mileageTrackingSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.MILEAGE_TRACKING, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.invoicesSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Invoices'),
                        value: pageState.invoicesSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.INVOICES, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 0.0),
                      alignment: Alignment.center,
                      height: 54.0,
                      decoration: BoxDecoration(
                          color: Color(pageState.analyticsSelected ? ColorConstants.getPeachLight() : ColorConstants.getPrimaryBackgroundGrey()),
                          borderRadius: BorderRadius.circular(36.0)),
                      child: CheckboxListTile(
                        title: Text('Business Analytics'),
                        value: pageState.analyticsSelected,
                        activeColor: Color(ColorConstants.getPeachDark()),
                        onChanged: (selected) {
                          pageState.onFeatureSelected(OnBoardingPageState.BUSINESS_ANALYTICS, selected);
                        },
                        controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if(pageState.featuresContinueEnabled) {
                      pageState.setPagerIndex(1);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(pageState.featuresContinueEnabled ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                        borderRadius: BorderRadius.circular(36.0)),
                    child: TextDandyLight(
                      text: 'Continue',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(pageState.featuresContinueEnabled ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
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
