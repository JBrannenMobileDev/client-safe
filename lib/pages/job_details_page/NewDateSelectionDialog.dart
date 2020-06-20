import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Event.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/JobCalendarItem.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsCalendarItem.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class NewDateSelectionDialog extends StatefulWidget {
  @override
  _NewDateSelectionDialogState createState() {
    return _NewDateSelectionDialogState();
  }
}

class _NewDateSelectionDialogState extends State<NewDateSelectionDialog> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime selectedDateTime;

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

  void _onDaySelected(DateTime day, List events, JobDetailsPageState pageState) {
    setState(() {
      _buildEventList(_getEventListForSelectedDate(pageState), pageState);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      onInit: (appState) => {
        appState.dispatch(FetchJobsForDateSelection(appState.state.jobDetailsPageState)),
        selectedDateTime = appState.state.jobDetailsPageState.job.selectedDate,
      },
      builder: (BuildContext context, JobDetailsPageState pageState) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 575.0,
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 4.0),
                child: Text(
                  "Select a new date for this job.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              _buildTableCalendarWithBuilders(pageState),
              const SizedBox(height: .0),
              Expanded(child: _buildEventList(_getEventListForSelectedDate(pageState), pageState)),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        pageState.onNewDateSelected(selectedDateTime);
                        VibrateUtil.vibrateHeavy();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(JobDetailsPageState pageState) {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: pageState.eventMap,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      initialSelectedDay: pageState.job.selectedDate,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,
        ),
        selectedStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        unavailableStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        todayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        outsideHolidayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        outsideStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        holidayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_black), fontSize: 20.0,
          fontFamily: 'simple',
          fontWeight: FontWeight.w600,),
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
        selectedDateTime = date;
        _onDaySelected(date, events, pageState);
        _animationController.forward(from: 0.0);
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _buildMultipleEvents(date, events)
    );
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
    } else if(events.length == 3) {
      return Row(
        children: <Widget>[
          blackEventDot(),
          blackEventDot(),
          blackEventDot(),
        ],
      );
    } else if(events.length == 2) {
      return Row(
        children: <Widget>[
          blackEventDot(),
          blackEventDot(),
        ],
      );
    } else if(events.length == 1) {
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
          shape: BoxShape.circle,
          color: Color(ColorConstants.primary_black)
      ),
    );
  }

  Widget _buildEventList(List<Job> eventsForSelectedDay, JobDetailsPageState pageState) {
    return ListView(
      children: eventsForSelectedDay
          .map((job) => JobDetailsCalendarItem(job: job, paddingRight: 0.0, paddingLeft: 4.0, pageState: pageState,))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  List<Job> _getEventListForSelectedDate(JobDetailsPageState pageState) {
    if(pageState.job.selectedDate != null){
      for(List<Event> events in pageState.eventMap.values){
        for(Event event in events){
          if(event.selectedDate != null) {
            if (event.selectedDate.year == selectedDateTime.year &&
                event.selectedDate.month == selectedDateTime.month &&
                event.selectedDate.day == selectedDateTime.day) {
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
