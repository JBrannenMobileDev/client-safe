import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/pages/weekly_calendar_page/DailyCalendarEventsBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/Profile.dart';
import '../../utils/CalendarUtil.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'WeeklyCalendarPageActions.dart';
import 'WeeklyCalendarPageState.dart';

class WeeklyCalendarPage extends StatefulWidget {
  @override
  _WeeklyWeeklyCalendarPageState createState() {
    return _WeeklyWeeklyCalendarPageState();
  }
}

class _WeeklyWeeklyCalendarPageState extends State<WeeklyCalendarPage> with TickerProviderStateMixin {
  AnimationController? _animationController;
  List<EventDandyLight>? _events;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void _showDayEventsBottomSheet(BuildContext context, DateTime day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return DailyCalendarEventsBottomSheet(day);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, WeeklyCalendarPageState>(
      onInit: (store) async {
        PermissionStatus previousStatus = await UserPermissionsUtil.getPermissionStatus(Permission.calendarFullAccess);
        Profile profile = store.state.dashboardPageState!.profile!;
        bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.calendarFullAccess, context: context, profile: profile);
        if(isGranted) {
          if(!previousStatus.isGranted || !profile.calendarEnabled!) {
            UserOptionsUtil.showCalendarSelectionDialog(context, store.state.weeklyCalendarPageState!.onCalendarEnabled);
          } else {
            print('Fetching device events');
            store.dispatch(FetchWeeklyDeviceEvents(store.state.weeklyCalendarPageState!, DateTime.now(), store.state.dashboardPageState!.profile!.calendarEnabled!));
          }
        }
        store.dispatch(FetchAllWeeklyCalendarJobsAction(store.state.weeklyCalendarPageState!));
      },
      converter: (store) => WeeklyCalendarPageState.fromStore(store),
      builder: (BuildContext context, WeeklyCalendarPageState pageState) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5)
          ),
          margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          height: 108,
          child: _buildTableCalendarWithBuilders(pageState),
        ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(WeeklyCalendarPageState pageState) {
    _events = pageState.eventList;
    return TableCalendar(
      locale: 'en_US',
      eventLoader: (day) => _events!.where((event) => isSameDay(event.selectedDate,day)).toList(), //THIS IS IMPORTANT
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      onPageChanged: (focusedDay) {
        print('month = ${focusedDay.month}   day = ${focusedDay.day}');
        pageState.onWeekChanged!(focusedDay, pageState.isCalendarEnabled!);
      },
      onDaySelected: (DateTime selected, DateTime focused) {
        _showDayEventsBottomSheet(context, selected);
      },
      firstDay: DateTime.utc(2010, 10, 16).toLocal(),
      lastDay: DateTime.utc(2100, 3, 14).toLocal(),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryGreyDark()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        defaultTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        selectedTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        disabledTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        todayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        weekendTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        holidayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: 12,
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),  fontSize: 12,
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryGreyDark()),  fontSize: 12,
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController!),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
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
              color: Color(ColorConstants.getPrimaryGreyDark()).withOpacity(0.5),
            ),
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
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
      ), focusedDay: pageState.selectedDate ?? DateTime.now(),
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
          shape: BoxShape.circle, color: Color(!event.isPersonalEvent! ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryGreyDark())),
    );
  }
}
