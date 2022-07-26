import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as newJobActions;
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class CalendarPageState{
  final bool shouldClear;
  final List<EventDandyLight> eventList;
  final List<Job> jobs;
  final List<Calendar> deviceCalendars;
  final Function(DateTime) onDateSelected;
  final Function() onAddNewJobSelected;
  final DateTime selectedDate;
  final Calendar selectedDeviceCalendar;
  final Function(Job) onJobClicked;

  CalendarPageState({
    @required this.shouldClear,
    @required this.eventList,
    @required this.onDateSelected,
    @required this.selectedDate,
    @required this.onAddNewJobSelected,
    @required this.onJobClicked,
    @required this.jobs,
    @required this.deviceCalendars,
    @required this.selectedDeviceCalendar,
  });

  CalendarPageState copyWith({
    bool shouldClear,
    List<EventDandyLight> eventList,
    Function(DateTime) onDateSelected,
    DateTime selectedDate,
    List<Job> jobs,
    List<Calendar> deviceCalendars,
    Calendar selectedCalendar,
    Function() onAddNewJobSelected,
    Function(Job) onJobClicked,
  }){
    return CalendarPageState(
      shouldClear: shouldClear?? this.shouldClear,
      eventList: eventList?? this.eventList,
      onDateSelected: onDateSelected?? this.onDateSelected,
      selectedDate: selectedDate?? this.selectedDate,
      jobs: jobs ?? this.jobs,
      onAddNewJobSelected: onAddNewJobSelected?? this.onAddNewJobSelected,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      deviceCalendars: deviceCalendars ?? this.deviceCalendars,
      selectedDeviceCalendar: selectedDeviceCalendar ?? this.selectedDeviceCalendar,
    );
  }

  factory CalendarPageState.initial() => CalendarPageState(
    shouldClear: true,
    eventList: [],
    jobs: [],
    onDateSelected: null,
    selectedDate: DateTime.now(),
    onAddNewJobSelected: null,
    onJobClicked: null,
    deviceCalendars: [],
    selectedDeviceCalendar: null,
  );

  factory CalendarPageState.fromStore(Store<AppState> store) {
    return CalendarPageState(
      shouldClear: store.state.calendarPageState.shouldClear,
      eventList: store.state.calendarPageState.eventList,
      selectedDate: store.state.calendarPageState.selectedDate,
      jobs: store.state.calendarPageState.jobs,
      deviceCalendars: store.state.calendarPageState.deviceCalendars,
      selectedDeviceCalendar: store.state.calendarPageState.selectedDeviceCalendar,
      onAddNewJobSelected: () => store.dispatch(newJobActions.InitNewJobPageWithDateAction(store.state.newJobPageState, store.state.calendarPageState.selectedDate)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.calendarPageState, selectedDate)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
    );
  }

  @override
  int get hashCode =>
      shouldClear.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      onDateSelected.hashCode ^
      selectedDate.hashCode ^
      deviceCalendars.hashCode ^
      selectedDeviceCalendar.hashCode ^
      onJobClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CalendarPageState &&
              shouldClear == other.shouldClear &&
              eventList == other.eventList &&
              jobs == other.jobs &&
              onDateSelected == other.onDateSelected &&
              selectedDate == other.selectedDate &&
              deviceCalendars == other.deviceCalendars &&
              selectedDeviceCalendar == other.selectedDeviceCalendar &&
              onJobClicked == other.onJobClicked;
}