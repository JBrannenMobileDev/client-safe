import 'package:flutter/widgets.dart';

class KeyboardUtil {
  static void closeKeyboard(BuildContext context){
    FocusScope.of(context).unfocus();
  }
}