import 'package:flutter/material.dart';

class ColorConstants{

  //App colors
  static const int black_overlay_light = 0x25000000;
  static const int black_overlay_medium = 0x50000000;
  static const int black_overlay_dark = 0x75000000;
  static const int primary = 0xFF92CEE3;
  static const int primary_dark = 0xFF4EAFCF;
  static const int primary_light = 0xff718792;
  static const int primary_accent = 0xfff4b642;
  static const int primary_bg_grey = 0xffF5F5F6;

  static int getUserColor(int colorId){
    switch(colorId){
      case 1: return color1;
      case 2: return color2;
      case 3: return color3;
      case 4: return color4;
      case 5: return color5;
      case 6: return color6;
      case 7: return color7;
      case 8: return color8;
      case 9: return color9;
      case 10: return color10;
      case 11: return color11;
      case 12: return color12;
      case 13: return color13;
      case 14: return color14;
      case 15: return color15;
      case 16: return color16;
    }
    return Colors.amber.value;
  }

  static int getUserColorDark(int colorId){
    switch(colorId){
      case 1: return color1_dark;
      case 2: return color2_dark;
      case 3: return color3_dark;
      case 4: return color4_dark;
      case 5: return color5_dark;
      case 6: return color6_dark;
      case 7: return color7_dark;
      case 8: return color8_dark;
      case 9: return color9_dark;
      case 10: return color10_dark;
      case 11: return color11_dark;
      case 12: return color12_dark;
      case 13: return color13_dark;
      case 14: return color14_dark;
      case 15: return color15_dark;
      case 16: return color16_dark;
    }
    return Colors.amber.value;
  }
  //User Colors
  static const int color1 = 0xffb92828;
  static const int color1_dark = 0xff871d1d;
  static const int color2 = 0xff34b728;
  static const int color2_dark = 0xff34841e;
  static const int color3 = 0xff177e2d;
  static const int color3_dark = 0xff186922;
  static const int color4 = 0xff28b35d;
  static const int color4_dark = 0xff1d8444;
  static const int color5 = 0xff29b486;
  static const int color5_dark = 0xff1d7e5e;
  static const int color6 = 0xff29b2b4;
  static const int color6_dark = 0xff1c7879;
  static const int color7 = 0xff2986b4;
  static const int color7_dark = 0xff1c5b7b;
  static const int color8 = 0xff2964b6;
  static const int color8_dark = 0xff1c447c;
  static const int color9 = 0xff2836b6;
  static const int color9_dark = 0xff1e298b;
  static const int color10 = 0xff412f86;
  static const int color10_dark = 0xff36276e;
  static const int color11 = 0xff6a43bf;
  static const int color11_dark = 0xff4e308e;
  static const int color12 = 0xffe7db28;
  static const int color12_dark = 0xff89820b;
  static const int color13 = 0xffff8426;
  static const int color13_dark = 0xffb16711;
  static const int color14 =0xfffd3232;
  static const int color14_dark = 0xffba1720;
  static const int color15 = 0xff101d8b;
  static const int color15_dark = 0xff0a135b;
  static const int color16 = 0xfff139d5;
  static const int color16_dark = 0xffb92aa3;
}