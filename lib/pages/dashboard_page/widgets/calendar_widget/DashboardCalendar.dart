import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarBox.dart';
import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarDayName.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class DashboardCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 16.0),
      height: 85.0,
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary_bg_grey),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: ElevationToShadow.values.elementAt(1),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            height: 24.0,
            decoration: BoxDecoration(
              color: const Color(ColorConstants.primary),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
            ),
          ),
          PageView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CalendarDayName(dayName: "Today"),
                        CalendarDayName(dayName: "Thurs"),
                        CalendarDayName(dayName: "Fri"),
                        CalendarDayName(dayName: "Sat"),
                        CalendarDayName(dayName: "Sun"),
                        CalendarDayName(dayName: "Mon"),
                        CalendarDayName(dayName: "Tues"),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "8"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "9"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "10"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "11"),
                      ),
                      Container(
                        height: 61.0,
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
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "13"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "14"),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CalendarDayName(dayName: "Today"),
                        CalendarDayName(dayName: "Thurs"),
                        CalendarDayName(dayName: "Fri"),
                        CalendarDayName(dayName: "Sat"),
                        CalendarDayName(dayName: "Sun"),
                        CalendarDayName(dayName: "Mon"),
                        CalendarDayName(dayName: "Tues"),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "8"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "9"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "10"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "11"),
                      ),
                      Container(
                        height: 61.0,
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
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "13"),
                      ),
                      Container(
                        height: 61.0,
                        width: 1.0,
                        color: const Color(ColorConstants.primary_divider),
                      ),
                      Expanded(
                        flex: 1,
                        child: CalendarBox(dayOfMonth: "14"),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
