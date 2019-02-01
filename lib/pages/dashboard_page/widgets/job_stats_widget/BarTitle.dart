import 'package:flutter/material.dart';

class BarTitle extends StatelessWidget{
  BarTitle({this.barName});

  final String barName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        barName,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w500,
            color: Colors.white),
      ),
    );
  }
}