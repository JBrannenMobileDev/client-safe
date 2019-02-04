import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarBox.dart';
import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarDayName.dart';
import 'package:client_safe/pages/dashboard_page/widgets/calendar_widget/CalendarRow.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/HostDetectionUtil.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class JobsCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: HostDetectionUtil.isIos(context) ? EdgeInsets.fromLTRB(0.0, 62.0, 0.0, 0.0) : EdgeInsets.fromLTRB(0.0, 42.0, 0.0, 0.0),
      decoration: BoxDecoration(
        color: const Color(ColorConstants.primary_bg_grey),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            height: 48.0,
            decoration: BoxDecoration(
              color: const Color(ColorConstants.primary),
            ),
            child: Text(
              "January",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          PageView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
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
                  CalendarRow(52.0),
                  Container(
                    height: 1.0,
                    color: const Color(ColorConstants.primary_divider),
                  ),
                  CalendarRow(52.0),
                  Container(
                    height: 1.0,
                    color: const Color(ColorConstants.primary_divider),
                  ),
                  CalendarRow(52.0),
                  Container(
                    height: 1.0,
                    color: const Color(ColorConstants.primary_divider),
                  ),
                  CalendarRow(52.0),
                  Container(
                    height: 1.0,
                    color: const Color(ColorConstants.primary_divider),
                  ),
                  CalendarRow(52.0),
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
