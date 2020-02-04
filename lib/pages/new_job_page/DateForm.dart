import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/pages/calendar_page/JobCalendarItem.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DateForm extends StatefulWidget {
  @override
  _DateFormState createState() {
    return _DateFormState();
  }
}

class _DateFormState extends State<DateForm> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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

  void _onDaySelected(DateTime day, List events, NewJobPageState pageState) {
    setState(() {
      _buildEventList(_getEventListForSelectedDate(pageState));
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                "Select a date for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            pageState.selectedDate != null ? Text(
                DateFormat('MMM d, yyyy').format(pageState.selectedDate),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w800,
                  color: Color(ColorConstants.getPrimaryColor()),
                ),
              ) : SizedBox(height: 21.0,),
            _buildTableCalendarWithBuilders(pageState),
            const SizedBox(height: .0),
            Expanded(child: _buildEventList(_getEventListForSelectedDate(pageState))),
          ],
        ),
      ),
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(NewJobPageState pageState) {
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
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideWeekendStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        outsideHolidayStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        outsideStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_bg_grey_dark)),
        weekendStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
        holidayStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Color(ColorConstants.primary_black)),
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
              color: Color(ColorConstants.getCollectionColor1()),
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
      onVisibleDaysChanged: _onVisibleDaysChanged,
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

  Widget _buildEventList(List<Event> eventsForSelectedDay) {
    return ListView(
      children: eventsForSelectedDay
          .map((event) => JobCalendarItem(event: event))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  List<Event> _getEventListForSelectedDate(NewJobPageState pageState) {
    if(pageState.selectedDate != null){
      for(List<Event> events in pageState.eventMap.values){
        for(Event event in events){
          if(event.selectedDate.year == pageState.selectedDate.year &&
              event.selectedDate.month == pageState.selectedDate.month &&
              event.selectedDate.day == pageState.selectedDate.day){
            return events;
          }
        }
      }
    }
    return List();
  }
}