import 'package:flutter/widgets.dart';

class GlobalKeyUtil{
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static final GlobalKeyUtil instance = GlobalKeyUtil._internal();
  factory GlobalKeyUtil() => instance;

  GlobalKeyUtil._internal();
}