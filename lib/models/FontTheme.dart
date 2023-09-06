
import 'package:flutter/widgets.dart';

import '../widgets/TextDandyLight.dart';

class FontTheme {
  static const String OPEN_SANS = 'Open Sans';
  static const String MONTSERRAT  = 'Montserrat';
  static const String SIGNATURE1  = 'Signature1';
  static const String SIGNATURE2  = 'Signature2';
  static const String SIGNATURE3  = 'Signature3';
  static const String Walkaway  = 'Walkaway';
  static const String VanillaRavioli  = 'Vanilla Ravioli';
  static const String SafiraMarch  = 'Safira March';
  static const String RoundedElegance  = 'Rounded Elegance';
  static const String Roboto  = 'Roboto';
  static const String Raleway  = 'Raleway';
  static const String QuicksandLight  = 'Quicksand Light';
  static const String QuicksandBook  = 'Quicksand Book';
  static const String Princ  = 'Princ';
  static const String PlayfairDisplay  = 'Playfair Display';
  static const String Moredya  = 'Moredya';
  static const String MontserratAlternativesRegular  = 'Montserrat Alternatives Regular';
  static const String ModernSans  = 'Modern Sans';
  static const String Minimal  = 'Minimal';
  static const String Mermaid  = 'Mermaid';
  static const String Manrope  = 'Manrope';
  static const String LouisGeorgeCafe  = 'Louis George Cafe';
  static const String GreateVibes  = 'Greate Vibes';
  static const String GontserraRegular  = 'Gontserra Regular';
  static const String GeosansLight  = 'Geosans Light';
  static const String GaretBook  = 'Garet Book';
  static const String Dreaming  = 'Dreaming';
  static const String Cinzel  = 'Cinzel';
  static const String ChampagneLimousines  = 'Champagne & Limousines';
  static const String CaviarDreams  = 'Caviar Dreams';
  static const String Catchye  = 'Catchye';
  static const String BelgianoSerif  = 'Belgiano Serif';
  static const String AppleGaramond  = 'Apple Garamond';
  static const String AntipastoProExtraLight  = 'Antipasto Pro Extra Light';

  static List<String> getAllFonts() {
    return [
      OPEN_SANS,
      ModernSans,
      GeosansLight,
      MONTSERRAT,
      MontserratAlternativesRegular,
      GontserraRegular,
      Walkaway,
      VanillaRavioli,
      SafiraMarch,
      RoundedElegance,
      Roboto,
      Raleway,
      QuicksandLight,
      QuicksandBook,
      Princ,
      PlayfairDisplay,
      Moredya,
      Minimal,
      Mermaid,
      Manrope,
      LouisGeorgeCafe,
      GreateVibes,
      GaretBook,
      Dreaming,
      Cinzel,
      ChampagneLimousines,
      CaviarDreams,
      Catchye,
      BelgianoSerif,
      AppleGaramond,
      AntipastoProExtraLight,
      SIGNATURE1,
      SIGNATURE2,
      SIGNATURE3,
    ];
  }

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

  static EdgeInsets getIconPaddingForFont(String fontSize, String fontFamily) {
    switch(fontSize) {
      case TextDandyLight.BRAND_LOGO:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 8, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 8, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 24, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
            return EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 10);
          case ModernSans:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
          case GeosansLight:
            return EdgeInsets.only(left: 0, top: 4, right: 0, bottom: 0);
          case VanillaRavioli:
          case SafiraMarch:
          case RoundedElegance:
          case QuicksandBook:
          case QuicksandLight:
          case Minimal:
          case Mermaid:
          case GreateVibes:
          case Dreaming:
          case Cinzel:
          case Catchye:
          case AntipastoProExtraLight:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.EXTRA_EXTRA_LARGE_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.EXTRA_LARGE_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.LARGE_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.MEDIUM_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.SMALL_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 0, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
      case TextDandyLight.EXTRA_SMALL_TEXT:
        switch(fontFamily) {
          case SIGNATURE1:
            return EdgeInsets.only(left: 0, top: 32, right: 16, bottom: 0);
            break;
          case SIGNATURE2:
            return EdgeInsets.only(left: 8, top: 16, right: 0, bottom: 0);
            break;
          case SIGNATURE3:
            return EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0);
            break;
          case OPEN_SANS:
          default:
            return EdgeInsets.all(0);
            break;
        }
        break;
    }
  }

  static double getIconFontSize(String fontSize, String fontFamily) {
    double size = 0;
    switch(fontSize) {
      case TextDandyLight.BRAND_LOGO:
        size = getIconFontByFontAndSize(72, fontFamily);
        break;
      case TextDandyLight.BRAND_LOGO_SMALL:
        size = getIconFontByFontAndSize(58, fontFamily);
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
        return fontSize;
        break;
      case SIGNATURE2:
      case SafiraMarch:
        return fontSize-16;
        break;
      case GreateVibes:
      case SIGNATURE3:
        return fontSize+16;
        break;
      case ModernSans:
      case GeosansLight:
      case MONTSERRAT:
      case MontserratAlternativesRegular:
      case GontserraRegular:
      case Walkaway:
      case VanillaRavioli:
      case RoundedElegance:
      case Roboto:
      case Raleway:
      case QuicksandLight:
      case QuicksandBook:
      case Princ:
      case PlayfairDisplay:
      case Moredya:
      case Minimal:
      case Mermaid:
      case Manrope:
      case LouisGeorgeCafe:
      case GaretBook:
      case Dreaming:
      case Cinzel:
      case ChampagneLimousines:
      case CaviarDreams:
      case Catchye:
      case BelgianoSerif:
      case AppleGaramond:
      case AntipastoProExtraLight:
      case OPEN_SANS:
        return fontSize+32;
        break;
      default:
        return fontSize;
        break;
    }
  }
}