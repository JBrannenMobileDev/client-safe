import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarBox.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class CalendarRow extends StatelessWidget{
  CalendarRow(this.height);
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "8"),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "9"),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "10"),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "11"),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(
            dayOfMonth: "12",
            clientName: "Shawna Brannen",
          ),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "13"),
        ),
        Container(
          height: height,
          width: 1.0,
          color: const Color(ColorConstants.primary_divider),
        ),
        Expanded(
          flex: 1,
          child: CalendarBox(dayOfMonth: "14"),
        ),
      ],
    );
  }

}