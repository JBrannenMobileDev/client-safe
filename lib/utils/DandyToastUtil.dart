import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
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
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void showToast(String msg) {
    HapticFeedback.heavyImpact();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(ColorConstants.getBlueDark()),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}