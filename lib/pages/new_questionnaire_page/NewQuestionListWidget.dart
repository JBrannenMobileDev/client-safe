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
                  Container(
                    height: 54.0,
                    width: 54.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(0)),
                      color: getBasedOnIndex(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: getIconFromType(),
                    ),
                  ),
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
      margin: const EdgeInsets.only(right: 56, left: 16),
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

  Color getBasedOnIndex() {
    Color result = Color(ColorConstants.getPrimaryBlack()).withOpacity(.35);

    switch(question.type) {
      case Question.TYPE_SHORT_FORM_RESPONSE:
        result = Color(ColorConstants.getPeachDark());
        break;
      case Question.TYPE_LONG_FORM_RESPONSE:
        result = Color(ColorConstants.getPeachLight());
        break;
      case Question.TYPE_CONTACT_INFO:
        result = Color(ColorConstants.getBlueDark()).withOpacity(0.8);
        break;
      case Question.TYPE_CHECK_BOXES:
        result = Color(ColorConstants.getPrimaryBlack()).withOpacity(.35);
        break;
      case Question.TYPE_NUMBER:
        result = Color(ColorConstants.getPeachDark());
        break;
      case Question.TYPE_YES_NO:
        result = Color(ColorConstants.getPeachLight());
        break;
      case Question.TYPE_RATING:
        result = Color(ColorConstants.getBlueDark()).withOpacity(0.8);
        break;
      case Question.TYPE_MULTIPLE_CHOICE:
        result = Color(ColorConstants.getPrimaryBlack()).withOpacity(.35);
        break;
      case Question.TYPE_DATE:
        result = Color(ColorConstants.getPeachDark());
        break;
      case Question.TYPE_ADDRESS:
        result = Color(ColorConstants.getPeachLight());
        break;
    }
    return result;
  }

  Widget getIconFromType() {
    Widget result = const SizedBox();

    switch(question.type) {
      case Question.TYPE_SHORT_FORM_RESPONSE:
        result = Image.asset('assets/images/icons/short_form.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_LONG_FORM_RESPONSE:
        result = Image.asset('assets/images/icons/long_form.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_CONTACT_INFO:
        result = Image.asset('assets/images/icons/contact_book.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_CHECK_BOXES:
        result = Image.asset('assets/images/icons/checkbox.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_NUMBER:
        result = Padding(
          padding: const EdgeInsets.all(3),
          child: Image.asset('assets/images/icons/number_sign.png', color: Color(ColorConstants.getPrimaryBlack()))
        );
        break;
      case Question.TYPE_MULTIPLE_CHOICE:
        result = Image.asset('assets/images/icons/radio_button.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_ADDRESS:
        result = Image.asset('assets/images/icons/pin_white.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_DATE:
        result = Image.asset('assets/images/icons/calendar.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_RATING:
        result = Icon(Icons.stars, color: Color(ColorConstants.getPrimaryBlack()));
        break;
      case Question.TYPE_YES_NO:
        result = Image.asset('assets/images/icons/checkbox.png', color: Color(ColorConstants.getPrimaryBlack()));
        break;
    }
    return result;
  }
}
