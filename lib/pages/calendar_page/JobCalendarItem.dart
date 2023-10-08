import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class JobCalendarItem extends StatelessWidget{
  final Job job;
  final EventDandyLight eventDandyLight;
  final double paddingLeft;
  final double paddingRight;
  final Function(Job) onJobClicked;
  JobCalendarItem({this.job, this.eventDandyLight, this.paddingLeft, this.paddingRight, this.onJobClicked});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        if(job != null) {
          onJobClicked(job);
          NavigationUtil.onJobTapped(context, false);
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 18.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 18.0, top: 4.0),
                  height: 38.0,
                  width: 38.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: job != null ? job.stage.getStageImage() : AssetImage('assets/images/icons/schedule_grey_dark.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
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
                              text: job != null ? job.jobTitle : eventDandyLight.eventTitle,
                              textAlign: TextAlign.start,
                              color: Color(job != null ? ColorConstants.getPrimaryBlack() : ColorConstants.primary_bg_grey_dark),
                            ),
                          ),
                          job != null ? (job.selectedDate != null && job.selectedTime != null && job.location != null && job.priceProfile != null
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
                        text: 'Stage: ' + job.stage.stage,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ) : SizedBox(),
                      job != null ? TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: _getSubtext(job),
                        textAlign: TextAlign.start,
                        color: job.selectedDate != null && job.selectedTime != null && job.location != null && job.priceProfile != null
                            ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPeachDark()),
                      ) : TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: DateFormat('EEE, MMM d').format(eventDandyLight.start) + ' · ' + DateFormat('h:mm a').format(eventDandyLight.start) + ' - ' + DateFormat('h:mm a').format(eventDandyLight.end),
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
    if(job.selectedDate != null && job.selectedTime != null && job.location != null && job.priceProfile != null){
      return DateFormat('EEE, MMM d').format(job.selectedDate) + ' · ' + DateFormat('h:mm a').format(job.selectedTime);
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
    if(job.priceProfile == null){
      return 'Price package not selected!';
    }
    return '';
  }
}