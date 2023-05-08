import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
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
            margin: EdgeInsets.only(left: 16, top: 54, right: 16, bottom: 0),
            child: ListView(
              children: [
                Container(  add back button
                  margin: EdgeInsets.only(left: 24, right: 24),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    isBold: true,
                    text: "Do you have any scheduled jobs?",
                    color: Color(ColorConstants.getPrimaryBlack()),
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
