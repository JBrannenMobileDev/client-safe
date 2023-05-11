import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';

class DoYouHaveAJobPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _DoYouHaveAJobPage();
  }
}

class _DoYouHaveAJobPage extends State<DoYouHaveAJobPage> {
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
            margin: EdgeInsets.only(left: 16, top: 64, right: 16, bottom: 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    Container(  //add back button
                      margin: EdgeInsets.only(left: 24, right: 24, bottom: 32),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        isBold: true,
                        text: "Do you currently have any scheduled jobs?",
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pageState.onHasJobAnswered(OnBoardingPageState.HAS_JOB_YES);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                            height: 54,
                            decoration: BoxDecoration(
                                color: Color(pageState.selectedOptionHasJob == OnBoardingPageState.HAS_JOB_YES ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                                borderRadius: BorderRadius.circular(36.0)),
                            child: TextDandyLight(
                              text: 'YES',
                              type: TextDandyLight.LARGE_TEXT,
                              color: Color(pageState.selectedOptionHasJob == OnBoardingPageState.HAS_JOB_YES ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            pageState.onHasJobAnswered(OnBoardingPageState.HAS_JOB_NO);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                            height: 54,
                            decoration: BoxDecoration(
                                color: Color(pageState.selectedOptionHasJob == OnBoardingPageState.HAS_JOB_NO ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                                borderRadius: BorderRadius.circular(36.0)),
                            child: TextDandyLight(
                              text: 'NO',
                              type: TextDandyLight.LARGE_TEXT,
                              color: Color(pageState.selectedOptionHasJob == OnBoardingPageState.HAS_JOB_NO ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: TextDandyLight(
                        text: buildMessage(pageState),
                        type: TextDandyLight.MEDIUM_TEXT,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        switch(pageState.selectedOptionHasJob) {
                          case OnBoardingPageState.HAS_JOB_YES:
                            UserOptionsUtil.showNewJobDialog(context);
                            break;
                          case OnBoardingPageState.HAS_JOB_NO:
                            pageState.onViewSampleJobSelected();
                            NavigationUtil.onJobTapped(context);
                            break;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 32.0),
                        alignment: Alignment.center,
                        height: 54.0,
                        decoration: BoxDecoration(
                            color: Color(pageState.selectedOptionHasJob.isNotEmpty ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryBackgroundGrey()),
                            borderRadius: BorderRadius.circular(36.0)),
                        child: TextDandyLight(
                          text: 'Continue',
                          type: TextDandyLight.LARGE_TEXT,
                          color: Color(pageState.selectedOptionHasJob.isNotEmpty ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }

  buildMessage(OnBoardingPageState pageState) {
    String result = '';
    switch(pageState.selectedOptionHasJob) {
      case '':
        break;
      case OnBoardingPageState.HAS_JOB_YES:
        result = 'Lets get started by adding your first job to Dandylight!';
        break;
      case OnBoardingPageState.HAS_JOB_NO:
        result = 'Lets get started by checking out our example job.';
        break;
    }
    return result;
  }
}
