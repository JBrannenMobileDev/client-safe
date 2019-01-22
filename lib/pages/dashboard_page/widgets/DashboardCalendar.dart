import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:client_safe/utils/Shadows.dart';

class DashboardCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 500.0),
        height: 85.0,
        decoration: BoxDecoration(
          color: const Color(ColorConstants.primary_bg_grey),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          boxShadow: ElevationToShadow.values.elementAt(1),
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: const Color(ColorConstants.primary),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
              ),
              padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "S",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "M",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "T",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: const Color(ColorConstants.primary_dark)),
                  ),
                  Text(
                    "W",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "TH",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "F",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "S",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[],
            )
          ],
        ));
  }
}
