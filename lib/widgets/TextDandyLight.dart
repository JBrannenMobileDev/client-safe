import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/TextFormatterUtil.dart';

class TextDandyLight extends StatelessWidget {
  static const String EXTRA_EXTRA_LARGE_TEXT = 'extra_extra_large_text';
  static const String EXTRA_LARGE_TEXT = 'extra_large_text';
  static const String LARGE_TEXT = 'large_text';
  static const String MEDIUM_TEXT = 'medium_text';
  static const String SMALL_TEXT = 'small_text';
  static const String EXTRA_SMALL_TEXT = 'extra_small_text';

  static getFontFamily() {
    return 'OpenSans';
  }

  static getFontWeight() {
    return FontWeight.w300;
  }

  static getFontSize(String type) {
    double size = 18;
    switch(type) {
      case EXTRA_EXTRA_LARGE_TEXT:
        size = 46;
        break;
      case EXTRA_LARGE_TEXT:
        size = 30;
        break;
      case LARGE_TEXT:
        size = 22;
        break;
      case MEDIUM_TEXT:
        size = 18;
        break;
      case SMALL_TEXT:
        size = 16;
        break;
      case EXTRA_SMALL_TEXT:
        size = 14;
        break;
    }
    return size;
  }

  double amount;
  final String type;
  String text = '';
  double size;
  String fontFamily;
  bool isBold;
  Color color;
  TextAlign textAlign;
  final VoidCallback onClick;
  int decimalPlaces = 2;
  bool isCurrency;
  bool isNumber;
  TextOverflow overflow;
  int maxLines;
  bool addShadow = false;

  TextDandyLight({
    @required this.type,
    this.text,
    this.fontFamily,
    this.isBold,
    this.color,
    this.onClick,
    this.textAlign,
    this.isNumber,
    this.amount,
    this.isCurrency,
    this.overflow,
    this.maxLines,
    this.decimalPlaces,
    this.addShadow,
  });

  @override
  Widget build(BuildContext context) {
    if(isBold == null) isBold = false;
    if(color == null) color = Color(ColorConstants.getPrimaryBlack());
    if(textAlign == null) textAlign = TextAlign.start;
    if(decimalPlaces == null) decimalPlaces = 2;
    if(isCurrency == null) isCurrency = false;
    if(isNumber == null) isNumber = false;
    if(addShadow == null) addShadow = false;
    fontFamily = isBold ? 'OpenSans' : 'OpenSans';
    if(isNumber) {
      text = NumberFormat("###,###,###,###").format(amount);
    }
    if(isCurrency) {
      text = TextFormatterUtil.formatDecimalDigitsCurrency(amount, decimalPlaces);
    }
    if(text == null) {
      text = '';
    }
    switch(type) {
      case EXTRA_EXTRA_LARGE_TEXT:
        size = 48;
        break;
      case EXTRA_LARGE_TEXT:
        size = 32;
        break;
      case LARGE_TEXT:
        size = 20;
        break;
      case MEDIUM_TEXT:
        size = 16;
        break;
      case SMALL_TEXT:
        size = 14;
        break;
      case EXTRA_SMALL_TEXT:
        size = 12;
        break;
    }
    return Container(
      child: onClick == null
          ? Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
          color: color,
          shadows: <Shadow>[
            addShadow ? Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 10.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ) : Shadow(),
          ],
        ),
      )
          : TextButton(
        onPressed: () {
          onClick.call();
        },
        child: Text(
          text,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: size,
            fontWeight: isBold ? FontWeight.w400 : FontWeight.w300,
            color: color,
            shadows: <Shadow>[
              addShadow ? Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 10.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ) : Shadow(),
            ],
          ),
        ),
      ),
    );
  }
}