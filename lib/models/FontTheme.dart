
import 'package:flutter/widgets.dart';

import '../widgets/TextDandyLight.dart';

class FontTheme {
  static const String OPEN_SANS = 'Open Sans';
  static const String MONTSERRAT  = 'Montserrat';
  static const String SIGNATURE1  = 'Signature1';
  static const String SIGNATURE2  = 'Signature2';

  static const String ICON_FONT_ID = 'icon_font';
  static const String TITLE_FONT_ID = 'title_font';
  static const String BODY_FONT_ID = 'body_font';

  int id;
  String themeName;
  String iconFont;
  String titleFont;
  String bodyFont;

  FontTheme({
    this.id,
    this.themeName,
    this.iconFont,
    this.titleFont,
    this.bodyFont,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'themeName' : themeName,
      'iconFont' : iconFont,
      'titleFont' : titleFont,
      'bodyFont' : bodyFont,
    };
  }

  static FontTheme fromMap(Map<String, dynamic> map) {
    return FontTheme(
      id: map['id'],
      themeName: map['themeName'],
      iconFont: map['iconFont'],
      titleFont: map['titleFont'],
      bodyFont: map['bodyFont'],
    );
  }

  static List<String> getAllFonts() {
    return [
      OPEN_SANS,
      MONTSERRAT,
      SIGNATURE1,
      SIGNATURE2,
    ];
  }

  static EdgeInsets getIconPaddingForFont(String fontFamily) {
    switch(fontFamily) {
      case SIGNATURE1:
        return EdgeInsets.only(left: 0, top: 20, right: 8, bottom: 0);
        break;
      case SIGNATURE2:
        return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
        break;
      case OPEN_SANS:
      default:
        return EdgeInsets.all(0);
        break;
    }
  }

  static double getIconFontSize(String fontSize, String fontFamily) {
    double size = 0;
    switch(fontSize) {
      case TextDandyLight.BRAND_LOGO:
        size = getIconFontByFontAndSize(72, fontFamily);
        break;
      case TextDandyLight.EXTRA_EXTRA_LARGE_TEXT:
        size = 48;
        break;
      case TextDandyLight.EXTRA_LARGE_TEXT:
        size = 32;
        break;
      case TextDandyLight.LARGE_TEXT:
        size = 20;
        break;
      case TextDandyLight.MEDIUM_TEXT:
        size = 16;
        break;
      case TextDandyLight.SMALL_TEXT:
        size = 14;
        break;
      case TextDandyLight.EXTRA_SMALL_TEXT:
        size = 12;
        break;
    }
    return size;
  }

  static double getIconFontByFontAndSize(double fontSize, String fontFamily) {
    switch(fontFamily) {
      case SIGNATURE1:
        return fontSize-8;
        break;
      case SIGNATURE2:
        return fontSize-32;
        break;
      case OPEN_SANS:
      case MONTSERRAT:
      default:
        return fontSize;
        break;
    }
  }
}