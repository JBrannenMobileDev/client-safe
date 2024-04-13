import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/CalendarUtil.dart';
import '../../widgets/TextDandyLight.dart';

class NewDateSelectionDialog extends StatefulWidget {
  @override
  _NewDateSelectionDialogState createState() {
    return _NewDateSelectionDialogState();
  }
}

class _NewDateSelectionDialogState extends State<NewDateSelectionDialog> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
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

  void _onDaySelected(DateTime day, List events, JobDetailsPageState pageState) {
    setState(() {
      CalendarUtil.buildEventList(
        pageState.job!.selectedDate,
        pageState.eventList,
        pageState.job!.selectedDate!.year,
        pageState.job!.selectedDate!.month,
        pageState.job!.selectedDate!.day,
        pageState.jobs,
        pageState.onJobClicked,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      onInit: (appState) => {
        appState.dispatch(FetchJobsForDateSelection(appState.state.jobDetailsPageState)),
      },
      builder: (BuildContext context, JobDetailsPageState pageState) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(

          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "Select a new date for this job.",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              _buildTableCalendarWithBuilders(pageState),
              const SizedBox(height: .0),
              Expanded(child: CalendarUtil.buildEventList(
                  pageState.selectedDate,
                  pageState.eventList,
                  pageState.selectedDate != null ? pageState.selectedDate!.year : DateTime.now().year,
                  pageState.selectedDate != null ? pageState.selectedDate!.month : DateTime.now().month,
                  pageState.selectedDate != null ? pageState.selectedDate!.day : DateTime.now().day,
                  pageState.jobs,
                  pageState.onJobClicked,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Cancel',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        pageState.onSaveSelectedDate!();
                        VibrateUtil.vibrateHeavy();
                        Navigator.of(context).pop();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Save',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
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
    _events = pageState.eventList;
    return TableCalendar(
      locale: 'en_US',
      eventLoader: (day) => _events!.where((event) => isSameDay(event.selectedDate ?? DateTime.now() ,day)).toList(), //THIS IS IMPORTANT,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2100, 3, 14),
      focusedDay: pageState.selectedDate ?? DateTime.now(),
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      onPageChanged: (focusedDay) {
        pageState.onMonthChanged!(focusedDay);
      },
      selectedDayPredicate: (day) => isSameDay(pageState.selectedDate ?? DateTime.now(), day),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        defaultTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        selectedTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        disabledTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        todayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.primary_bg_grey_dark),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        weekendTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        holidayTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
        weekendStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          color: Color(ColorConstants.getPrimaryBlack()),
          fontSize: TextDandyLight.getFontSize(TextDandyLight.SMALL_TEXT),
          fontFamily: TextDandyLight.getFontFamily(),
          fontWeight: TextDandyLight.getFontWeight(),
        ),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController!),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(ColorConstants.getPrimaryColor()),
              ),
              width: 100,
              height: 100,
              child: TextDandyLight(
                type: TextDandyLight.SMALL_TEXT,
                text: '${date.day}',
                color: Color(ColorConstants.getPrimaryBlack()),
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
            child: TextDandyLight(
              type: TextDandyLight.SMALL_TEXT,
              text: '${date.day}',
              color: Color(ColorConstants.getPrimaryBlack()),
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
      onDaySelected: (date, events) {
        pageState.onNewDateSelected!(date);
        _onDaySelected(date, _events!.where((event) => isSameDay(event.selectedDate,date)).toList(), pageState);
        _animationController!.forward(from: 0.0);
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
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
          blackEventDot(events.elementAt(2)),
          blackEventDot(events.elementAt(3)),
        ],
      );
    } else if(events.length == 3) {
      return Row(
        children: <Widget>[
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
          blackEventDot(events.elementAt(2)),
        ],
      );
    } else if(events.length == 2) {
      return Row(
        children: <Widget>[
          blackEventDot(events.elementAt(0)),
          blackEventDot(events.elementAt(1)),
        ],
      );
    } else if(events.length == 1) {
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
          shape: BoxShape.circle, color: Color(!event.isPersonalEvent! ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryBackgroundGrey())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
