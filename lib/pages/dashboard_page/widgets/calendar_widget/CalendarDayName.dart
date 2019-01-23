import 'package:flutter/material.dart';

class CalendarDayName extends StatelessWidget{
  CalendarDayName({this.dayName});

  final String dayName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        dayName,
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