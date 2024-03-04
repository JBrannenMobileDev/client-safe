import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../../models/Questionnaire.dart';
import '../../../widgets/TextDandyLight.dart';

class QuestionnaireDocument implements DocumentItem {
  final bool isComplete;
  final Questionnaire questionnaire;

  QuestionnaireDocument({this.isComplete = false, this.questionnaire});

  @override
  Widget buildIconItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 18.0, top: 0.0),
      height: 42.0,
      width: 42.0,
      child: Image.asset('assets/images/icons/questionnaire_solid.png', color: Color(ColorConstants.getPeachDark())),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: 'Questionnaire',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPrimaryBlack()),
        ),
        isComplete ? TextDandyLight(
          type: TextDandyLight.SMALL_TEXT,
          text: '(Completed)',
          textAlign: TextAlign.start,
          color: Color(ColorConstants.getPeachDark()),
        ) : TextDandyLight(
          type: TextDandyLight.SMALL_TEXT,
          text: questionnaire.title,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: Color(ColorConstants.getPrimaryBlack()),
        )
      ],
    );
  }

  @override
  String getDocumentType() {
    return DocumentItem.DOCUMENT_TYPE_QUESTIONNAIRE;
  }
}