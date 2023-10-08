import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:dandylight/pages/calendar_page/JobCalendarItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/CalendarUtil.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  AnimationController _animationController;
  List<EventDandyLight> _events;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, CalendarPageState pageState) {
    setState(() {
      CalendarUtil.buildEventList(
        pageState.selectedDate,
        pageState.eventList,
        pageState.selectedDate.year,
        pageState.selectedDate.month,
        pageState.selectedDate.day,
        pageState.jobs,
        pageState.onJobClicked,
      );
    });
  }

  void _FetchDeviceEvents() {

  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, CalendarPageState>(
      onInit: (store) async {
        store.dispatch(FetchAllCalendarJobsAction(store.state.calendarPageState));

        PermissionStatus previousStatus = await UserPermissionsUtil.getPermissionStatus(Permission.calendar);
        bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.calendar, context: context);
        if(isGranted) {
          if(!(await previousStatus.isGranted)) {
            UserOptionsUtil.showCalendarSelectionDialog(context, store.state.calendarPageState.onCalendarEnabled);
          } else {
            store.dispatch(FetchDeviceEvents(store.state.calendarPageState, DateTime.now(), store.state.dashboardPageState.profile.calendarEnabled));
          }
        }
      },
      converter: (store) => CalendarPageState.fromStore(store),
      builder: (BuildContext context, CalendarPageState pageState) => Scaffold(
        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: Device.get().isIphoneX ? 560.0 : 540.0,
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildTableCalendarWithBuilders(pageState),
                    const SizedBox(height: 8.0),
                    Expanded(
                        child: CalendarUtil.buildEventList(
                            pageState.selectedDate,
                            pageState.eventList,
                            pageState.selectedDate.year,
                            pageState.selectedDate.month,
                            pageState.selectedDate.day,
                            pageState.jobs,
                            pageState.onJobClicked,
                        ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 16.0),
                alignment: Alignment.topCenter,
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: "Calendar",
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(ColorConstants.getPrimaryBlack())
                  ),
                  tooltip: 'Add',
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: Icon(Icons.add),
            backgroundColor: Color(ColorConstants.getPrimaryColor()),
            onPressed: () {
              pageState.onAddNewJobSelected();
              UserOptionsUtil.showNewJobDialog(context, false);
              EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Calendar Page"});
            }),
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(CalendarPageState pageState) {
    _events = pageState.eventList;
    return TableCalendar(
      locale: 'en_US',
      eventLoader: (day) => _events.where((event) => isSameDay(event.selectedDate,day)).toList(), //THIS IS IMPORTANT
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      onPageChanged: (focusedDay) {
        pageState.onMonthChanged(focusedDay, pageState.isCalendarEnabled);
      },
      focusedDay: pageState.selectedDate,
      firstDay: DateTime.utc(2010, 10, 16).toLocal(),
      lastDay: DateTime.utc(2100, 3, 14).toLocal(),
      selectedDayPredicate: (day) => isSameDay(pageState.selectedDate, day),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        defaultTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        selectedTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        disabledTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        todayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        weekendTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        holidayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(ColorConstants.getPrimaryColor()),
              ),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontWeight: TextDandyLight.getFontWeight(),
                ),
              ),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(ColorConstants.getPeachDark()),
            ),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
                fontFamily: TextDandyLight.getFontFamily(),
                fontWeight: TextDandyLight.getFontWeight(),
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {

          if (events.isNotEmpty) {

              return Positioned(
                bottom: 1,
                child: _buildEventsMarker(date, events),
              );
          }

          return SizedBox.shrink();
        },
      ),
      onDaySelected: (date, time) {
        pageState.onDateSelected(date);
        _onDaySelected(date, _events.where((event) => isSameDay(event.selectedDate,date)).toList(), pageState);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: _buildMultipleEvents(date, events));
  }

  Widget _buildMultipleEvents(DateTime date, List events) {
    if (events.length > 3) {
      return Row(
        children: <Widget>[
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
          blackEventDot(events.elementAt(2)),
          blackEventDot(events.elementAt(3)),
        ],
      );
    } else if (events.length == 3) {
      return Row(
        children: <Widget>[
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
          blackEventDot(events.elementAt(2)),
        ],
      );
    } else if (events.length == 2) {
      return Row(
        children: <Widget>[
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
        ],
      );
    } else if (events.length == 1) {
      return blackEventDot(events.elementAt(0));
    } else {
      return SizedBox();
    }
  }

  Widget blackEventDot(EventDandyLight event) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color(!event.isPersonalEvent ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryBackgroundGrey())),
    );
  }
}
