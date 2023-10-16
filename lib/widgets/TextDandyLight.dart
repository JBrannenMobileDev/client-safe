import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/FontTheme.dart';
import '../utils/TextFormatterUtil.dart';

class TextDandyLight extends StatelessWidget {
  static const String BRAND_LOGO = 'brand_logo';
  static const String BRAND_LOGO_SMALL = 'brand_logo_small';
  static const String INCOME_EXPENSE_TOTAL = 'income_expense_total';
  static const String EXTRA_EXTRA_LARGE_TEXT = 'extra_extra_large_text';
  static const String EXTRA_LARGE_TEXT = 'extra_large_text';
  static const String LARGE_TEXT = 'large_text';
  static const String MEDIUM_TEXT = 'medium_text';
  static const String SMALL_TEXT = 'small_text';
  static const String EXTRA_SMALL_TEXT = 'extra_small_text';

  static getFontFamily() {
    return 'Open Sans';
  }

  static getFontWeight() {
    return FontWeight.w300;
  }

  static getFontSize(String type) {
    double size = 18;
    switch(type) {
      case BRAND_LOGO:
        size = 76;
        break;
      case BRAND_LOGO_SMALL:
        size = 58;
        break;
      case INCOME_EXPENSE_TOTAL:
        size = 52;
        break;
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
  bool isThin;
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
    this.isThin,
  });

  @override
  Widget build(BuildContext context) {
    if(isBold == null) isBold = false;
    if(isThin == null) isThin = false;
    if(color == null) color = Color(ColorConstants.getPrimaryBlack());
    if(textAlign == null) textAlign = TextAlign.start;
    if(decimalPlaces == null) decimalPlaces = 2;
    if(isCurrency == null) isCurrency = false;
    if(isNumber == null) isNumber = false;
    if(addShadow == null) addShadow = false;
    if(fontFamily == null) fontFamily = getFontFamily();
    if(isNumber) {
      text = NumberFormat("###,###,###,###").format(amount);
    }
    if(isCurrency) {
      text = TextFormatterUtil.formatDecimalDigitsCurrency(amount, decimalPlaces);
    }
    if(text == null) {
      text = '';
    }

    if(fontFamily == FontTheme.MONTSERRAT) {
      isBold = false;
    }

    if(fontFamily == FontTheme.Raleway) {
      isBold = false;
    }

    size = FontTheme.getIconFontSize(type, fontFamily);

    if(fontFamily == FontTheme.SIGNATURE2) {
      size = size + 6;
    }

    if(fontFamily == FontTheme.SIGNATURE1) {
      size = size + 8;
    }

    if(fontFamily == FontTheme.Princ) {
      size = size + 8;
    }

    if(fontFamily == FontTheme.Minimal) {
      size = size + 6;
    }

    return Container(
      padding: FontTheme.getIconPaddingForFont(type, fontFamily),
      child: onClick == null
          ? Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: isBold ? FontWeight.bold : isThin ? FontWeight.w100 : FontWeight.w300,
          color: color,
          shadows: <Shadow>[
            addShadow ? Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Colors.black38,
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
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black38,
              ) : Shadow(),
            ],
          ),
        ),
      ),
    );
  }
}