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
  final List<Event> deviceEvents;
  final bool isCalendarEnabled;
  final Function(DateTime) onDateSelected;
  final Function() onAddNewJobSelected;
  final DateTime selectedDate;
  final Function(Job) onJobClicked;
  final Function(DateTime, bool) onMonthChanged;
  final Function(bool) onCalendarEnabled;

  CalendarPageState({
    @required this.shouldClear,
    @required this.eventList,
    @required this.onDateSelected,
    @required this.selectedDate,
    @required this.onAddNewJobSelected,
    @required this.onJobClicked,
    @required this.jobs,
    @required this.deviceEvents,
    @required this.onMonthChanged,
    @required this.onCalendarEnabled,
    @required this.isCalendarEnabled,
  });

  CalendarPageState copyWith({
    bool shouldClear,
    List<EventDandyLight> eventList,
    Function(DateTime) onDateSelected,
    DateTime selectedDate,
    List<Job> jobs,
    List<Event> deviceEvents,
    Function() onAddNewJobSelected,
    Function(Job) onJobClicked,
    Function(DateTime, bool) onMonthChanged,
    Function(bool) onCalendarEnabled,
    bool isCalendarEnabled,
  }){
    return CalendarPageState(
      shouldClear: shouldClear?? this.shouldClear,
      eventList: eventList?? this.eventList,
      onDateSelected: onDateSelected?? this.onDateSelected,
      selectedDate: selectedDate?? this.selectedDate,
      jobs: jobs ?? this.jobs,
      onAddNewJobSelected: onAddNewJobSelected?? this.onAddNewJobSelected,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      deviceEvents: deviceEvents ?? this.deviceEvents,
      onMonthChanged: onMonthChanged ?? this.onMonthChanged,
      onCalendarEnabled: onCalendarEnabled ?? this.onCalendarEnabled,
      isCalendarEnabled: isCalendarEnabled ?? this.isCalendarEnabled,
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
    deviceEvents: [],
    onMonthChanged: null,
    onCalendarEnabled: null,
    isCalendarEnabled: false,
  );

  factory CalendarPageState.fromStore(Store<AppState> store) {
    return CalendarPageState(
      shouldClear: store.state.calendarPageState.shouldClear,
      eventList: store.state.calendarPageState.eventList,
      selectedDate: store.state.calendarPageState.selectedDate,
      jobs: store.state.calendarPageState.jobs,
      deviceEvents: store.state.calendarPageState.deviceEvents,
      isCalendarEnabled: store.state.calendarPageState.isCalendarEnabled,
      onAddNewJobSelected: () => store.dispatch(newJobActions.InitNewJobPageWithDateAction(store.state.newJobPageState, store.state.calendarPageState.selectedDate)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.calendarPageState, selectedDate)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
      onMonthChanged: (month, isCalendarEnabled) => store.dispatch(FetchDeviceEvents(store.state.calendarPageState, month, isCalendarEnabled)),
      onCalendarEnabled: (enabled) {
        store.dispatch(UpdateCalendarEnabledAction(store.state.calendarPageState, enabled));
        store.dispatch(FetchDeviceEvents(store.state.calendarPageState, DateTime.now(), enabled));
      },
    );
  }

  @override
  int get hashCode =>
      shouldClear.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      onCalendarEnabled.hashCode ^
      onDateSelected.hashCode ^
      selectedDate.hashCode ^
      deviceEvents.hashCode ^
      onJobClicked.hashCode ^
      isCalendarEnabled.hashCode ^
      onMonthChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CalendarPageState &&
              shouldClear == other.shouldClear &&
              eventList == other.eventList &&
              jobs == other.jobs &&
              onDateSelected == other.onDateSelected &&
              selectedDate == other.selectedDate &&
              deviceEvents == other.deviceEvents &&
              onMonthChanged == other.onMonthChanged &&
              onCalendarEnabled == other.onCalendarEnabled &&
              isCalendarEnabled == other.isCalendarEnabled &&
              onJobClicked == other.onJobClicked;
}