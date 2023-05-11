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
  bool hasViewedSampleJob = false;

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
                            UserOptionsUtil.showNewJobDialog(context);
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16),
                                margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                                alignment: Alignment.topCenter,
                                height: 132.0,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: TextDandyLight(
                                  text: 'Lets get started by adding your job and contact to Dandylight!',
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                                height: 54,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getBlueDark()),
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: TextDandyLight(
                                  text: 'YES',
                                  type: TextDandyLight.LARGE_TEXT,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        GestureDetector(
                          onTap: () {
                            pageState.onViewSampleJobSelected();
                            NavigationUtil.onJobTapped(context);
                            hasViewedSampleJob = true;
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16),
                                margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                                alignment: Alignment.topCenter,
                                height: 132.0,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: TextDandyLight(
                                  text: 'Lets get started by viewing a example job before entering the app.',
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                                height: 54,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    borderRadius: BorderRadius.circular(36.0)),
                                child: TextDandyLight(
                                  text: 'NO',
                                  type: TextDandyLight.LARGE_TEXT,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                hasViewedSampleJob ? GestureDetector(
                  onTap: () {
                    NavigationUtil.onSuccessfulLogin(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 0.0, bottom: 32.0),
                    alignment: Alignment.center,
                    height: 54.0,
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPeachDark()),
                        borderRadius: BorderRadius.circular(36.0)),
                    child: TextDandyLight(
                      text: 'Continue',
                      type: TextDandyLight.LARGE_TEXT,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
