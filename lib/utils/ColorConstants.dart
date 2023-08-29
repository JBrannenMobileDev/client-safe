
import 'dart:math';
import 'dart:ui';

class ColorConstants{

  //Set 1
  static const int black_overlay_light = 0x25000000;
  static const int black_overlay_medium = 0x50000000;
  static const int black_overlay_dark = 0x75000000;
  static const int primary_black = 0xff444444;
  static const int primary = 0xFF00c6f2;
  static const int error_red = 0xffed4337;

  static const int primary_pricing_profile = 0xffFD716D;
  static const int primary_locations = 0xff93DEAC;

  static const int primary_dark = 0xFF00b2e3;
  static const int primary_light = 0xffeaf9ff;
  static const int primary_button_negative_grey = 0xffe6e6e6;
  static const int primary_bg_grey = 0xffD4D5C7;
  static const int primary_bg_grey_dark = 0xffD4D5C7;
  static const int primary_divider = 0xffe0e0e0;
  static const int white = 0xffffffff;

  //Set 3
  static const int gold = 0xffE6CE97;
  static const int gold_dark = 0xffE6CE97;
  static const int blue_dark = 0xff557571;
  static const int blue_light = 0xffd6ddd8;
  static const int peach_dark = 0xffd49a89;
  static const int peach_light = 0xffFBE3D6;
  static const int grey_alt = 0xff868982;
  static const int grey = 0xffe3e1da;
  static const int grey_medium = 0xffD2D0C9;
  static const int charcoal = 0xff504B47;
  static const int black = 0xff444444;

  static const String banner = 'banner';
  static const String button = 'button';
  static const String buttonText = 'buttonText';
  static const String icon = 'icon';
  static const String iconText = 'iconText';

  static String getHex(Color color) {
    return color.value.toRadixString(16).substring(2);
  }

  static String getString(int color) {
    return color.toRadixString(16).substring(2);
  }

  static int getPrimaryColor(){
    return gold;
  }
  static int getPrimaryDarkColor(){
    return gold_dark;
  }

  static int getPrimaryWhite(){
    return white;
  }

  static int getPrimaryBackgroundGrey(){
    return grey;
  }

  static int getPrimaryGreyMedium() {
    return grey_medium;
  }

  static int getPeachDark(){
    return peach_dark;
  }

  static int getBlueDark(){
    return blue_dark;
  }

  static int getPeachLight(){
    return peach_light;
  }

  static int getBlueLight(){
    return blue_light;
  }

  static int getPrimaryBlack() {
    return black;
  }

  static int getPieChartColor(int index) {
    List<int> colors = [gold, peach_dark, blue_light, blue_dark, peach_light, grey ];
    while(index > 5) {
      index = index - 6;
    }
    return colors.elementAt(index);
  }

  static int getRandomProfileColor() {
    List<int> colors = [gold, peach_dark, blue_light, blue_dark, peach_light];
    var intValue = Random().nextInt(5);
    return colors[intValue];
  }

  static isWhite(Color color) {
    return color.value == 4294967295;
  }

  static isWhiteString(String color) {
    return color == 'ffffff';
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code, radix: 16) + 0xFF000000);
  }
}