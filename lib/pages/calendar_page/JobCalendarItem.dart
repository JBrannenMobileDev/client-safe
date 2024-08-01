import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class JobCalendarItem extends StatelessWidget{
  final Job? job;
  final EventDandyLight? eventDandyLight;
  JobCalendarItem({this.job, this.eventDandyLight});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        if(job != null) {
          NavigationUtil.onJobTapped(context, false, job!.documentId!);
        } else {
          DandyToastUtil.showErrorToast('Not a Dandylight event');
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 18.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 18.0, top: 4.0),
                  height: 26.0,
                  width: 26.0,
                  child: job != null ? job!.stage!.getStageImage(Color(ColorConstants.getPeachDark())) : Image.asset('assets/images/icons/calendar.png', color: Color(ColorConstants.getBlueLight()),),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(

                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: job != null ? job!.jobTitle : eventDandyLight!.eventTitle,
                              textAlign: TextAlign.start,
                              color: Color(job != null ? ColorConstants.getPrimaryBlack() : ColorConstants.primary_bg_grey_dark),
                            ),
                          ),
                          job != null ? (job!.selectedDate != null && job!.selectedTime != null && job!.location != null && job!.sessionType != null
                              ? SizedBox() : Container(
                            margin: EdgeInsets.only(left: 8.0),
                            height: 20.0,
                            width: 20.0,
                            child: Image(
                              image: AssetImage('assets/images/alert.png'),
                            ),
                          )) : SizedBox(),
                        ],
                      ),
                      job != null ? TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: _getSubtext(job!),
                        textAlign: TextAlign.start,
                        color: job?.selectedDate != null && job?.selectedTime != null && job?.location != null && job?.sessionType != null
                            ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPeachDark()),
                      ) : TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: '${DateFormat('h:mm a').format(eventDandyLight!.start!)} - ${DateFormat('h:mm a').format(eventDandyLight!.end!)}',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_bg_grey_dark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            job != null ? Container(
              child: Icon(
                Icons.chevron_right,
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }

  String _getSubtext(Job job) {
    if(job.selectedDate != null && job.selectedTime != null && job.location != null && job.sessionType != null){
      if((job.sessionType?.durationMinutes ?? 0) > 0 || (job.sessionType?.durationHours ?? 0) > 0) {
        DateTime endTime = job.selectedTime!.add(Duration(
          hours: job.sessionType?.durationHours ?? 0,
          minutes: job.sessionType?.durationMinutes ?? 0,
        ));
        return '${DateFormat('h:mm a').format(job.selectedTime!)} - ${DateFormat('h:mm a').format(endTime)}';
      } else {
        return DateFormat('h:mm a').format(job.selectedTime!);
      }
    }
    if(job.selectedDate == null){
      return 'Date not selected!';
    }
    if(job.selectedTime == null){
      return 'Time not selected!';
    }
    if(job.location == null){
      return 'Location not selected!';
    }
    if(job.sessionType == null){
      return 'Price package not selected!';
    }
    return '';
  }
}