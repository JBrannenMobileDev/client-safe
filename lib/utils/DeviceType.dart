import 'package:flutter/widgets.dart';

enum Type { Phone, Tablet, Website }

class DeviceType {
  static Type getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? Type.Phone : data.size.shortestSide < 1080 ? Type.Tablet : Type.Website;
  }

  static Type getDeviceTypeByContext(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < 550 ? Type.Phone : width < 1080 ? Type.Tablet : Type.Website;
  }
}