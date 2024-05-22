import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';

class JobDetailsCalendarItem extends StatelessWidget{
  final Job? job;
  final double? paddingLeft;
  final double? paddingRight;
  final JobDetailsPageState? pageState;
  JobDetailsCalendarItem({this.job, this.paddingLeft, this.paddingRight, this.pageState});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        if(job!.documentId != null && job!.documentId!.isNotEmpty) {
          NavigationUtil.onJobTapped(context, false, job!.documentId!);
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
                  child: job!.stage!.getStageImage(Color(ColorConstants.getPeachDark())),
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
                              text: job!.jobTitle,
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          job!.selectedDate != null && job!.selectedTime != null && job!.location != null && job!.priceProfile != null
                              ? SizedBox() : Container(
                            margin: EdgeInsets.only(left: 8.0),
                            height: 20.0,
                            width: 20.0,
                            child: Image(
                              image: AssetImage('assets/images/alert.png'),
                            ),
                          ),
                        ],
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Stage: ' + JobStage.getStageText(job!.stage!),
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: _getSubtext(job!),
                        textAlign: TextAlign.start,
                        color: job!.selectedDate != null && job!.selectedTime != null && job!.location != null && job!.priceProfile != null
                            ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPeachDark()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
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

  String _getSubtext(Job job) {
    if(job.selectedDate != null && job.selectedTime != null && job.location != null && job.priceProfile != null){
      return DateFormat('EEE, MMM d').format(job.selectedDate!) + ' · ' + DateFormat('h:mm a').format(job.selectedTime!);
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