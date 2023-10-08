import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class ReminderViewDialog extends StatefulWidget {
  ReminderViewDialog({this.jobReminder});

  final JobReminder jobReminder;

  @override
  _ReminderViewDialogState createState() {
    return _ReminderViewDialogState(jobReminder);
  }
}

class _ReminderViewDialogState extends State<ReminderViewDialog> with AutomaticKeepAliveClientMixin {
  final JobReminder jobReminder;

  _ReminderViewDialogState(this.jobReminder);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: BorderRadius.circular(16.0),
                ),

                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Job Reminder',
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 24.0, top: 56.0),
                      height: 48.0,
                      child: Image.asset('assets/images/icons/reminder_icon_blue_light.png'),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 74.0, top: 58.0, right: 16.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: jobReminder.reminder.description,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4.0),
                            width: MediaQuery.of(context).size.width,
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: jobReminder.reminder.when == 'on' ? 'Day of shoot' :
                              jobReminder.reminder.amount.toString() + ' ' + (jobReminder.reminder.amount == 1 ? jobReminder.reminder.daysWeeksMonths.substring(0, jobReminder.reminder.daysWeeksMonths.length - 1) : jobReminder.reminder.daysWeeksMonths) + ' ' + jobReminder.reminder.when,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56.0,
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.cancel, color: Color(ColorConstants.getPeachDark()),)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
