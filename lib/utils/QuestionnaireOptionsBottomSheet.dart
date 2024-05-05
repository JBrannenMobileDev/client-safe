import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import '../../widgets/TextDandyLight.dart';
import '../models/Profile.dart';
import '../models/Questionnaire.dart';

class QuestionnaireOptionsBottomSheet extends StatefulWidget {
  final bool isComplete;
  final Function openQuestionnaireEditPage;
  final Questionnaire questionnaire;
  final Profile profile;
  final Function(Questionnaire)? markQuestionnaireAsReviewed;

  QuestionnaireOptionsBottomSheet(this.isComplete, this.openQuestionnaireEditPage, this.questionnaire, this.profile, this.markQuestionnaireAsReviewed);


  @override
  State<StatefulWidget> createState() {
    return _QuestionnaireOptionsBottomSheetPageState(isComplete, openQuestionnaireEditPage, questionnaire, profile, markQuestionnaireAsReviewed);
  }
}

class _QuestionnaireOptionsBottomSheetPageState extends State<QuestionnaireOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final bool isComplete;
  final Function openQuestionnaireEditPage;
  final Questionnaire questionnaire;
  final Profile profile;
  final Function(Questionnaire)? markQuestionnaireAsReviewed;

  _QuestionnaireOptionsBottomSheetPageState(this.isComplete, this.openQuestionnaireEditPage, this.questionnaire, this.profile, this.markQuestionnaireAsReviewed);


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
                if(markQuestionnaireAsReviewed != null) {
                  markQuestionnaireAsReviewed!(questionnaire);
                }
                NavigationUtil.onAnswerQuestionnaireSelected(context, questionnaire, profile, '', '', true, false);
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
                  onTap: () async {
                    if(questionnaire.isInProgress()) {
                      await showDialog(
                      context: context,
                      builder: (_) => Device.get().isIos ?
                      CupertinoAlertDialog(
                        title: new Text('Questionnaire in progress!'),
                        content: new Text('This questionnaire is already partially answered. Do you still want to make changes?'),
                        actions: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              openQuestionnaireEditPage(context, questionnaire);
                            },
                            child: new Text('Yes'),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No'),
                          ),
                        ],
                      ) : AlertDialog(
                        title: new Text('Questionnaire in progress!'),
                        content: new Text('This questionnaire is already partially answered. Do you still want to make changes?'),
                        actions: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              openQuestionnaireEditPage(context, questionnaire);
                            },
                            child: new Text('Yes'),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No'),
                          ),
                        ],
                      ));
                    } else {
                      Navigator.of(context).pop();
                      openQuestionnaireEditPage(context, questionnaire);
                    }
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
                    NavigationUtil.onAnswerQuestionnaireSelected(context, questionnaire, profile, '', questionnaire.jobDocumentId, true, false);
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