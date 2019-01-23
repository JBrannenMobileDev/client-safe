import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61.0,
      width: 1.0,
      color: const Color(ColorConstants.primary_divider),
    );
  }

}