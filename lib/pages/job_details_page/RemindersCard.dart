import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../models/ReminderDandyLight.dart';
import '../../utils/UserOptionsUtil.dart';
import '../common_widgets/ClientSafeButton.dart';

class RemindersCard extends StatelessWidget {
  RemindersCard({this.pageState});

  final JobDetailsPageState pageState;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 26.0, bottom: 200.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                      child: Text(
                        'Reminders',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                ),
                pageState.reminders.length > 0
                    ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 335.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.reminders.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                      child: Text(
                        "You have not added any reminders to this job yet. Select the (+) icon to add a reminder.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    JobReminder jobReminder = pageState.reminders.elementAt(index);
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: null,
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    height: 32.0,
                    width: 32.0,
                    child: Image.asset(
                      'assets/images/collection_icons/reminder_icon_white.png', color: Color(ColorConstants.getPeachDark()),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      jobReminder.reminder.description,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                pageState.onDeleteReminderSelected(jobReminder);
              },
              child: Container(
                margin: EdgeInsets.only(right: 8.0),
                height: 24.0,
                width: 24.0,
                child: Image.asset('assets/images/icons/trash_icon_peach.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showNewReminderCard(BuildContext context) {
    UserOptionsUtil.showNewJobReminderDialog(context, pageState.job);
  }
}
