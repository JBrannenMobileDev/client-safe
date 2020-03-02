import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageActions.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageState.dart';
import 'package:client_safe/pages/calendar_page/JobCalendarItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:table_calendar/table_calendar.dart';

class TwoWeekCalendarPage extends StatefulWidget {
  @override
  _TwoWeekCalendarPageState createState() {
    return _TwoWeekCalendarPageState();
  }
}

class _TwoWeekCalendarPageState extends State<TwoWeekCalendarPage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
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
      onInit: (store) =>
          store.dispatch(FetchAllJobsAction(store.state.calendarPageState)),
      converter: (store) => CalendarPageState.fromStore(store),
      builder: (BuildContext context, CalendarPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Schedule',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Blackjack',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                Icons.event,
                                size: 28.0,
                                color: Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            tooltip: 'Calendar',
                            onPressed: () {
                              NavigationUtil.onCalendarSelected(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildTableCalendarWithBuilders(pageState),
                    Expanded(
                        child: _buildEventList(_getEventListForSelectedDate(pageState), pageState)),
                  ],
                ),
              ),
          ],
        ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(CalendarPageState pageState) {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: pageState.eventMap,
      initialCalendarFormat: CalendarFormat.twoWeeks,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      initialSelectedDay: pageState.selectedDate,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle()
            .copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        outsideHolidayStyle: TextStyle()
            .copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        outsideStyle: TextStyle()
            .copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        weekendStyle:
            TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
        holidayStyle:
            TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
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
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
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
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        pageState.onDateSelected(date);
        _onDaySelected(date, events, pageState);
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
    if (pageState.selectedDate != null) {
      for (List<Event> events in pageState.eventMap.values) {
        for (Event event in events) {
          if(event.selectedDate != null){
            if (event.selectedDate.year == pageState.selectedDate.year &&
                event.selectedDate.month == pageState.selectedDate.month &&
                event.selectedDate.day == pageState.selectedDate.day) {
              return _getListOfJobsFromEvents(events, pageState.jobs);
            }
          }
        }
      }
    }
    return List();
  }

  List<Job> _getListOfJobsFromEvents(List<Event> events, List<Job> allJobs) {
    List<Job> jobs = List();
    for(Event event in events){
      for(Job job in allJobs){
        if(job.id == event.jobId) jobs.add(job);
      }
    }
    return jobs;
  }
}
