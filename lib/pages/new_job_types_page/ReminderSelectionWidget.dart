import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/common_widgets/ClientSafeButton.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageState.dart';
import 'package:dandylight/pages/new_job_types_page/ReminderSelectionListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


class ReminderSelectionWidget extends StatefulWidget {
  @override
  _ReminderSelectionPageState createState() {
    return _ReminderSelectionPageState();
  }
}

class _ReminderSelectionPageState extends State<ReminderSelectionWidget> with AutomaticKeepAliveClientMixin {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(ColorConstants.getPrimaryBlack());
      }
      return Color(ColorConstants.getPeachDark());
    }

    return StoreConnector<AppState, NewJobTypePageState>(
      onInit: (store) {
        store.dispatch(FetchAllRemindersAction(store.state.newJobReminderPageState));
      },
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 0.0, left: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Select what reminders you want for this job type. You may also add your own.",
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                pageState.allDandyLightReminders.length > 0 ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Check All',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        checkColor: Color(ColorConstants.getPrimaryWhite()),
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: pageState.checkAllReminders,
                        onChanged: (bool isChecked) {
                          pageState.checkAllRemindersChecked(isChecked);
                        },
                      ),
                    ),
                  ],
                ) : SizedBox(),
                pageState.allDandyLightReminders.length > 0
                    ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                    maxHeight: 450.0,
                  ),
                  child: ListView.builder(
                    reverse: false,
                    padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                    shrinkWrap: true,
                    controller: _controller,
                    physics: ClampingScrollPhysics(),
                    itemCount: pageState.allDandyLightReminders.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: "You have not created any reminders yet.",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
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
                        color: ColorConstants.getBlueDark()
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
  return StoreConnector<AppState, NewJobTypePageState>(
    converter: (store) => NewJobTypePageState.fromStore(store),
    builder: (BuildContext context, NewJobTypePageState pageState) =>
        ReminderSelectionListWidget(pageState, index),
  );
}
