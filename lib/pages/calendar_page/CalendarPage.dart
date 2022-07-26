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

import '../../utils/UserPermissionsUtil.dart';

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
      _buildEventList(_getEventListForSelectedDate(pageState), pageState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalendarPageState>(
      onInit: (store) async {
        store.dispatch(FetchAllJobsAction(store.state.calendarPageState));
        store.dispatch(FetchDeviceCalendars(store.state.calendarPageState));

        PermissionStatus readContactsStatus = await UserPermissionsUtil.getPermissionStatus(Permission.calendar);
        if(readContactsStatus == PermissionStatus.denied || readContactsStatus == PermissionStatus.permanentlyDenied){
          await UserPermissionsUtil.requestPermission(Permission.calendar);
        }
      },
      onDidChange: (previousState, newState) {
        if(newState.deviceCalendars.isNotEmpty && newState.selectedDeviceCalendar == null) {
          UserOptionsUtil.showSelectCalendarDialog(context);
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
              color: Colors.white,
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
                        child: _buildEventList(_getEventListForSelectedDate(pageState), pageState)),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 16.0),
                alignment: Alignment.topCenter,
                child: Text(
                  "Calendar",
                  style: TextStyle(
                    fontFamily: 'simple',
                    color: const Color(ColorConstants.primary_black),
                    fontSize: 26.0,
                    fontWeight: FontWeight.w800,
                  ),
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
              UserOptionsUtil.showNewJobDialog(context);
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
      focusedDay: pageState.selectedDate,
      firstDay: DateTime.utc(2010, 10, 16).toLocal(),
      lastDay: DateTime.utc(2100, 3, 14).toLocal(),
      selectedDayPredicate: (day) => isSameDay(pageState.selectedDate, day),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,
        ),
        defaultTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        selectedTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        disabledTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        todayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        weekendTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        holidayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 18.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
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
                    fontSize: 16.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
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
                  fontSize: 16.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
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
          blackEventDot(),
          blackEventDot(),
          blackEventDot(),
          blackEventDot(),
        ],
      );
    } else if (events.length == 3) {
      return Row(
        children: <Widget>[
          blackEventDot(),
          blackEventDot(),
          blackEventDot(),
        ],
      );
    } else if (events.length == 2) {
      return Row(
        children: <Widget>[
          blackEventDot(),
          blackEventDot(),
        ],
      );
    } else if (events.length == 1) {
      return blackEventDot();
    } else {
      return SizedBox();
    }
  }

  Widget blackEventDot() {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Color(ColorConstants.primary_black)),
    );
  }

  Widget _buildEventList(List<Job> eventsForSelectedDay, CalendarPageState pageState) {
    return ListView(
      children: eventsForSelectedDay
          .map((job) => JobCalendarItem(job: job, paddingRight: 24.0, paddingLeft: 24.0, pageState: pageState,))
          .toList(),
    );
  }

  List<Job> _getEventListForSelectedDate(CalendarPageState pageState) {
    List<EventDandyLight> matchingEvents = [];
    if (pageState.selectedDate != null) {
      for (EventDandyLight event in pageState.eventList) {
        if(event.selectedDate != null){
          if (event.selectedDate.year == pageState.selectedDate.year &&
              event.selectedDate.month == pageState.selectedDate.month &&
              event.selectedDate.day == pageState.selectedDate.day) {
            matchingEvents.add(event);
          }
        }
      }
    }
    if(matchingEvents.length > 0) {
      return _getListOfJobsFromEvents(matchingEvents, pageState.jobs);
    } else {
      return [];
    }
  }

  List<Job> _getListOfJobsFromEvents(List<EventDandyLight> events, List<Job> allJobs) {
    List<Job> jobs = [];
    for(EventDandyLight event in events){
      for(Job job in allJobs){
        if(job.documentId == event.jobDocumentId) jobs.add(job);
      }
    }
    return jobs;
  }
}
