import 'dart:io';

import 'package:dandylight/models/Question.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

import '../../utils/NavigationUtil.dart';
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
          NavigationUtil.onNewQuestionSelected(context, question, pageState.onQuestionSaved, position);
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(0), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(0)),
                    ),
                    child: question.showImage ? Container(
                      child: question.mobileImage != null ? Container(
                        height: 54,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                          child: Image(
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 54,
                            image: FileImage(File(question.mobileImage.path)),
                          ),
                        ),
                      ) : question.mobileImageUrl != null && question.mobileImageUrl.isNotEmpty ? Container(
                        height: 54,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: DandyLightNetworkImage(
                            question.mobileImageUrl,
                            color: Color(ColorConstants.getPeachDark()),
                            borderRadius: 0,
                            errorIconSize: 28,
                          ),
                        ),
                      ) : Padding(
                        padding: const EdgeInsets.all(10),
                        child: getIconFromType(question.type),
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.all(10),
                      child: getIconFromType(question.type),
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
          question.question != null && question.question.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
              text: question.question,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }

  static Color getColorBasedOnIndex(String type) {
    Color result = Color(ColorConstants.getPrimaryBlack()).withOpacity(.35);

    switch(type) {
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

  static Widget getIconFromType(String type) {
    Widget result = const SizedBox();

    switch(type) {
      case Question.TYPE_SHORT_FORM_RESPONSE:
        result = Image.asset('assets/images/icons/short_form.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_LONG_FORM_RESPONSE:
        result = Image.asset('assets/images/icons/long_form.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_CONTACT_INFO:
        result = Image.asset('assets/images/icons/contact_book.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_CHECK_BOXES:
        result = Image.asset('assets/images/icons/checkbox.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_NUMBER:
        result = Padding(
          padding: const EdgeInsets.all(3),
          child: Image.asset('assets/images/icons/number_sign.png', color: getColorBasedOnIndex(type), height: 26, width: 26)
        );
        break;
      case Question.TYPE_MULTIPLE_CHOICE:
        result = Image.asset('assets/images/icons/radio_button.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_ADDRESS:
        result = Image.asset('assets/images/icons/pin_white.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
      case Question.TYPE_DATE:
        result = Icon(Icons.calendar_today, color: getColorBasedOnIndex(type), size: 32);;
        break;
      case Question.TYPE_RATING:
        result = Icon(Icons.stars, color: getColorBasedOnIndex(type), size: 32);
        break;
      case Question.TYPE_YES_NO:
        result = Image.asset('assets/images/icons/checkbox.png', color: getColorBasedOnIndex(type), height: 32, width: 32);
        break;
    }
    return result;
  }
}
