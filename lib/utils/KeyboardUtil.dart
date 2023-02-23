import 'package:flutter/widgets.dart';

class KeyboardUtil {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0;
  }
}