
class ColorConstants{

  //Set 1
  static const int black_overlay_light = 0x25000000;
  static const int black_overlay_medium = 0x50000000;
  static const int black_overlay_dark = 0x75000000;
  static const int primary_black = 0xff444444;
  static const int primary = 0xFF00c6f2;

  static const int primary_pricing_profile = 0xffFD716D;
  static const int primary_locations = 0xff93DEAC;

  static const int primary_dark = 0xFF00b2e3;
  static const int primary_light = 0xffeaf9ff;
  static const int primary_button_negative_grey = 0xffe6e6e6;
  static const int primary_bg_grey = 0xffD4D5C7;
  static const int primary_bg_grey_dark = 0xffD4D5C7;
  static const int primary_divider = 0xffe0e0e0;
  static const int white = 0xffffffff;

  //Set 2
  static const int gold = 0xffD0AC58;
  static const int gold_dark = 0xffB49347;
  static const int blue_dark = 0xff4B6C6A;
  static const int blue_light = 0xffBDD5D0;
  static const int peach_dark = 0xffB9754B;
  static const int peach_light = 0xffCDA090;
  static const int grey_alt = 0xff868982;
  static const int grey = 0xffe3e1da;
  static const int charcoal = 0xff504B47;
  static const int black = 0xff444444;

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
}