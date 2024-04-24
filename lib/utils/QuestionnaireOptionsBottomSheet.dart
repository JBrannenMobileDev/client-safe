import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/TextDandyLight.dart';
import '../models/Profile.dart';
import '../models/Questionnaire.dart';

class QuestionnaireOptionsBottomSheet extends StatefulWidget {
  final bool isComplete;
  final Function openQuestionnaireEditPage;
  final Questionnaire questionnaire;
  final Profile profile;

  QuestionnaireOptionsBottomSheet(this.isComplete, this.openQuestionnaireEditPage, this.questionnaire, this.profile);


  @override
  State<StatefulWidget> createState() {
    return _QuestionnaireOptionsBottomSheetPageState(isComplete, openQuestionnaireEditPage, questionnaire, profile);
  }
}

class _QuestionnaireOptionsBottomSheetPageState extends State<QuestionnaireOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final bool isComplete;
  final Function openQuestionnaireEditPage;
  final Questionnaire questionnaire;
  final Profile profile;

  _QuestionnaireOptionsBottomSheetPageState(this.isComplete, this.openQuestionnaireEditPage, this.questionnaire, this.profile);


  @override
  Widget build(BuildContext context) =>
      Container(
        height: 264.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Questionnaire options',
              ),
            ),
            isComplete ? GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                openQuestionnaireEditPage(context, questionnaire);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                width: 264,
                height: 54,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'View Results',
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ) : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    openQuestionnaireEditPage(context, questionnaire);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    width: 264,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Color(ColorConstants.getPeachDark())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Edit Questionnaire',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    NavigationUtil.onInAppPreviewQuestionnaireSelected(context, questionnaire, profile);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 264,
                    height: 54,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: Color(ColorConstants.getPeachDark())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Preview Questionnaire',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}