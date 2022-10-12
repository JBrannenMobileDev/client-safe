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
            margin: EdgeInsets.only(left: 26.0, right: 26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Select from your collection of reminders.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                pageState.allReminders.length > 0
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
                          itemCount: pageState.allReminders.length,
                          itemBuilder: _buildItem,
                        ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                      child: Text(
                        "You have not created any collection reminders yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    ClientSafeButton(
                      height: 50.0,
                      width: 200.0,
                      text: "Add New Reminder",
                      marginLeft: 0.0,
                      marginRight: 0.0,
                      marginBottom: 0.0,
                      marginTop: 32.0,
                      onPressed: onAddNewReminderSelected,
                      urlText: "",
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
        NewReminderListWidget(pageState.allReminders.elementAt(index), pageState, pageState.onReminderSelected, Colors.white, Color(ColorConstants.getPrimaryBlack())),
  );
}
