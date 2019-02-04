import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobListWidget extends StatelessWidget {
  JobListWidget(this.jobName, this.clientName, this.date);

  final String jobName;
  final String clientName;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          height: 64.0,
          width: 64.0,
          decoration: BoxDecoration(
            color: const Color(ColorConstants.primary_bg_grey),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: ElevationToShadow.values.elementAt(1),
          ),
          child: Icon(
            Icons.person,
            color: const Color(ColorConstants.primary_dark),
            size: 64.0,
          ),
        ),
        Expanded(
          child: Container(
            height: 64.0,
            margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            decoration: BoxDecoration(
              color: const Color(ColorConstants.primary_bg_grey),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              boxShadow: ElevationToShadow.values.elementAt(1),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    jobName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      color: const Color(ColorConstants.primary_dark),
                    ),
                  ),
                  Text(
                    clientName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: const Color(ColorConstants.primary_dark),
                    ),
                  ),
                  Text(
                    "Scheduled date: " + DateFormat('MM-dd-yyyy').format(date),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: const Color(ColorConstants.primary_dark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
