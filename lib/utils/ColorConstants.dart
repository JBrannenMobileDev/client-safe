
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
  static const int gold = 0xffE1BD5B;
  static const int gold_dark = 0xffad9144;
  static const int goldDashboard = 0xffCBA63A;
  static const int blue = 0xffC2D3CB;
  static const int blue_light = 0xffBDD5D0;
  static const int peach_dark = 0xffCD755D;
  static const int peach_light = 0xffECA99A;
  static const int cream = 0xffFFffff;
  static const int grey = 0xffe3e1da;
  static const int green = 0xff31636D;
  static const int charcoal = 0xff504B47;
  static const int black = 0xff444444;

  static int getPrimaryColor(){
    return gold;
  }
  static int getPrimaryDarkColor(){
    return gold_dark;
  }

  static int getPrimaryColorForDashboard(){
    return goldDashboard;
  }

  static int getPrimaryWhite(){
    return cream;
  }

  static int getPrimaryBackgroundGrey(){
    return grey;
  }

  static int getCollectionColor1(){
    return peach_dark;
  }

  static int getCollectionColor2(){
    return green;
  }

  static int getCollectionColor3(){
    return peach_light;
  }

  static int getCollectionColor4(){
    return gold;
  }

  static int getPrimaryBlack() {
    return black;
  }
}