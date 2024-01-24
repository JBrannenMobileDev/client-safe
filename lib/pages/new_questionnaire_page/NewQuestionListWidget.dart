import 'package:dandylight/models/Question.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewQuestionnairePageState.dart';

class NewQuestionListWidget extends StatelessWidget {
  final Question question;
  NewQuestionnairePageState pageState;

  NewQuestionListWidget(this.question, this.pageState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {

        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(ColorConstants.getPrimaryWhite())
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 96.0,
                    width: 96.0,
                    margin: const EdgeInsets.only(right: 16.0),
                    child: DandyLightNetworkImage(
                        question.imageUrl,
                      borderRadius: 16,
                      borderRadiusOnly: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(0)),
                      resizeWidth: 350,
                      errorIconSize: 32,
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: question.type,
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              height: 32,
              width: 32,
              alignment: Alignment.centerRight,
              child: Image.asset('assets/images/icons/reorder.png'),
            ),
          ],
        ),
      );
  }

  Widget buildQuestionDetails(Question question) {
    Widget result = const SizedBox();

    return result;
  }
}
