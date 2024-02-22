import 'package:dandylight/pages/questionnaires_page/SendQuestionnaireBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';

import '../../models/Questionnaire.dart';
import '../../widgets/TextDandyLight.dart';

class QuestionnaireListWidget extends StatelessWidget {
  final Questionnaire questionnaire;
  var pageState;
  final Function onQuestionnaireSelected;
  final Color backgroundColor;
  final Color textColor;

  QuestionnaireListWidget(this.questionnaire, this.pageState, this.onQuestionnaireSelected, this.backgroundColor, this.textColor, {Key key}) : super(key: key);

  void showSendBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SendQuestionnaireBottomSheet(questionnaire);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: Styles.getButtonStyle(
          color: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          onQuestionnaireSelected(pageState, context, questionnaire);
        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            SizedBox(
              height: 56.0,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                    height: 36.0,
                    width: 36.0,
                    child: Image.asset('assets/images/collection_icons/questionaire_icon_white.png', color: Color(ColorConstants.getBlueDark())),
                  ),
                  SizedBox(
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: questionnaire.title,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showSendBottomSheet(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(ColorConstants.getBlueDark()),
                ),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'SEND',
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            )
          ],
        ),
      );
  }
}
