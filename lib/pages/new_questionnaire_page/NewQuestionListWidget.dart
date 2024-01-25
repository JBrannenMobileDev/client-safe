import 'package:dandylight/models/Question.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewQuestionnairePageState.dart';

class NewQuestionListWidget extends StatelessWidget {
  final Question question;
  final int position;
  NewQuestionnairePageState pageState;

  NewQuestionListWidget(this.question, this.pageState, this.position, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {

        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(ColorConstants.getPrimaryWhite())
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  question.showImage ? Container(
                    height: 54.0,
                    width: 54.0,
                    child: DandyLightNetworkImage(
                        question.imageUrl,
                      borderRadius: 16,
                      borderRadiusOnly: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(0)),
                      resizeWidth: 350,
                      errorIconSize: 32,
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                  ) : const SizedBox(),
                  Expanded(
                    child: buildQuestionDetails(),
                  )
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

  Widget buildQuestionDetails() {
    return Container(
      margin: EdgeInsets.only(right: 56, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
              text: question.type,
              textAlign: TextAlign.start,
              isBold: true,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
              text: question.question,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
        ],
      ),
    );
  }
}
