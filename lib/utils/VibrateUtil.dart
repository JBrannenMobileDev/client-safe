import 'package:flutter/services.dart';

class VibrateUtil {
  static void vibrateMedium() async {
    HapticFeedback.mediumImpact();
  }

  static void vibrateLight() async {
    HapticFeedback.lightImpact();
  }

  static void vibrateHeavy() async {
    HapticFeedback.heavyImpact();
  }

  static void vibrate() async {
    HapticFeedback.vibrate();
  }
}