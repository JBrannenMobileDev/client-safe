import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobClientListWidget.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobStagesListWidget.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewReminderItemListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobReminderSelectionForm extends StatefulWidget {
  @override
  _JobReminderSelectionFormState createState() {
    return _JobReminderSelectionFormState();
  }
}

class _JobReminderSelectionFormState extends State<JobReminderSelectionForm>  with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> jobStageIcons = ImageUtil.jobStageIcons;

    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 16.0),
                  child: Text(
                    'Please select reminders for this job.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 64.0),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.allReminders.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobPageState>(
    converter: (store) => NewJobPageState.fromStore(store),
    builder: (BuildContext context, NewJobPageState pageState) =>
        JobReminderItemListWidget(index),
  );
}
