import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DandyToastUtil {
  static void showErrorToast(String msg) {
    HapticFeedback.heavyImpact();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(ColorConstants.getPeachDark()),
        textColor: Color(ColorConstants.getPrimaryWhite()),
        fontSize: 16.0
    );
  }

  static void showToast(String msg, Color color) {
    HapticFeedback.heavyImpact();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: color,
        textColor: Color(ColorConstants.getPrimaryWhite()),
        fontSize: 16.0,
    );
  }

  static void showToastWithGravity(String msg, Color color, ToastGravity gravity) {
    HapticFeedback.heavyImpact();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Color(ColorConstants.getPrimaryWhite()),
      fontSize: 18.0,
    );
  }
}