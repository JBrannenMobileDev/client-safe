import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';

import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';

class RemindersCard extends StatelessWidget {
  RemindersCard({Key key, this.pageState}) : super(key: key);

  final JobDetailsPageState pageState;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 26.0, bottom: 200.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'Reminders',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                ),
                pageState.reminders.isNotEmpty
                    ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 65.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 24.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: const ClampingScrollPhysics(),
                    itemCount: pageState.reminders.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: "You have not added any reminders to this job yet. Select the (+) icon to add a reminder.",
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
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
      onPressed: () {
        UserOptionsUtil.showReminderViewDialog(context, jobReminder);
      },
      child: SizedBox(
        height: 54.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    height: 32.0,
                    width: 32.0,
                    child: Image.asset(
                      'assets/images/collection_icons/reminder_icon_white.png', color: Color(ColorConstants.getPeachDark()),),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: jobReminder.reminder.description,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      color: Color(ColorConstants.getPrimaryBlack()),
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
                margin: const EdgeInsets.only(right: 8.0),
                height: 24.0,
                width: 24.0,
                child: Image.asset('assets/images/icons/trash_can.png', color: Color(ColorConstants.getPeachDark())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
