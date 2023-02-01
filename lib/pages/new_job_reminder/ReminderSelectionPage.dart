import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'NewReminderListWidget.dart';

class ReminderSelectionPage extends StatefulWidget {
  @override
  _ReminderSelectionPageState createState() {
    return _ReminderSelectionPageState();
  }
}

class _ReminderSelectionPageState extends State<ReminderSelectionPage> with AutomaticKeepAliveClientMixin {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobReminderPageState>(
      onInit: (store) {
        store.dispatch(FetchAllRemindersAction(store.state.newJobReminderPageState));
      },
      converter: (store) => NewJobReminderPageState.fromStore(store),
      builder: (BuildContext context, NewJobReminderPageState pageState) =>
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Select from your collection of reminders.",
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                pageState.allReminders.length > 0
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 65.0,
                          maxHeight: 500.0,
                        ),
                        child: ListView.builder(
                          reverse: false,
                          shrinkWrap: true,
                          controller: _controller,
                          physics: ClampingScrollPhysics(),
                          itemCount: pageState.allReminders.length,
                          itemBuilder: _buildItem,
                        ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 64.0, right: 64.0, top: 64.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.hasNotCreatedAnyReminders ?
                        "You have not created any collection reminders yet." : "All of your reminders are already added to this job.",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    ClientSafeButton(
                      height: 50.0,
                      width: 200.0,
                      text: "New Reminder",
                      marginLeft: 0.0,
                      marginRight: 0.0,
                      marginBottom: 0.0,
                      marginTop: 32.0,
                      onPressed: onAddNewReminderSelected,
                      urlText: "",
                      color: ColorConstants.getBlueDark(),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void onAddNewReminderSelected() {
    UserOptionsUtil.showNewReminderDialog(context, null);
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, NewJobReminderPageState>(
    converter: (store) => NewJobReminderPageState.fromStore(store),
    builder: (BuildContext context, NewJobReminderPageState pageState) =>
        NewReminderListWidget(pageState.allReminders.elementAt(index), pageState, pageState.onReminderSelected, Colors.white, Color(ColorConstants.getPrimaryBlack()), index),
  );
}
