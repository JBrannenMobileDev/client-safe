import 'package:flutter/material.dart';

class HostDetectionUtil{
  static bool isIos(BuildContext context){
    return Theme.of(context).platform == TargetPlatform.iOS;
  }
}