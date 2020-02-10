import 'package:client_safe/models/Event.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobCalendarItem extends StatelessWidget{
  final Event event;
  JobCalendarItem({this.event});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => NavigationUtil.onClientTapped(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 16.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 18.0, top: 4.0),
                  height: 42.0,
                  width: 42.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: event.icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          event.eventTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Text(
                        event.nextStageText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        event.selectedDate != null ? DateFormat('EEE, MMM d').format(event.selectedDate) + ' · ' + DateFormat('h:mm a').format(event.selectedTime) : '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.chevron_right,
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
              ),
            )
          ],
        ),
      ),
    );
  }
}