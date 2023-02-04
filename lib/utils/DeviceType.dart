import 'package:flutter/widgets.dart';

enum Type { Phone, Tablet }

class DeviceType {
  static Type getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? Type.Phone : Type.Tablet;
  }
}