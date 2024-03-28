import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionActions.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageState.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CalendarSelectionPage extends StatefulWidget {
  final Function(bool)? onCalendarChanged;

  CalendarSelectionPage(this.onCalendarChanged);

  @override
  State<StatefulWidget> createState() {
    return _CalendarSelectionPageState(onCalendarChanged);
  }
}

class _CalendarSelectionPageState extends State<CalendarSelectionPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  final Function(bool)? onCalendarPermissionsChanged;

  _CalendarSelectionPageState(this.onCalendarPermissionsChanged);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarSelectionPageState>(
        onInit: (store) => store.dispatch(FetchWritableCalendars(store.state.calendarSelectionPageState)),
        converter: (store) => CalendarSelectionPageState.fromStore(store),
        builder: (BuildContext context, CalendarSelectionPageState pageState) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 100, bottom: 50),
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 8.0, left: 4.0),
                  height: 30.0,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      pageState.onCancelSelected!();
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Color(ColorConstants.getPrimaryBlack()),
                      size: 30.0,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: "Calendar Selection",
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 56.0, left: 16, right: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: "Please select what calendars you would like to sync with the DandyLight calendar",
                    color: Color(ColorConstants.getPrimaryBlack()),
                    textAlign: TextAlign.center,
                  ),
                ),
                pageState.writableCalendars!.length > 0 ? Container(
                  margin: const EdgeInsets.only(top: 124.0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: const ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: pageState.writableCalendars!.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : Container(
                  margin: const EdgeInsets.only(top: 188, left: 24, right: 24),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    textAlign: TextAlign.center,
                    text: "Please restart Dandylight app for calendar permissions to be applied. \n\nAfter restart your device calendars will be listed here.",
                    color: const Color(ColorConstants.error_red),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      if(onCalendarPermissionsChanged != null) {
                        onCalendarPermissionsChanged!(true);
                      }
                      pageState.onSaveSelected!();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 32.0),
                      height: 54.0,
                      width: 200.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getPeachDark()),
                          borderRadius: BorderRadius.circular(27.0)
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Save",
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, CalendarSelectionPageState>(
    converter: (store) => CalendarSelectionPageState.fromStore(store),
    builder: (BuildContext context, CalendarSelectionPageState pageState) =>
        CalendarWidget(index),
  );
}
