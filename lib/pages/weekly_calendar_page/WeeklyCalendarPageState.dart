import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as newJobActions;
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'WeeklyCalendarPageActions.dart';

class WeeklyCalendarPageState{
  final bool? shouldClear;
  final List<EventDandyLight>? eventList;
  final List<Job>? jobs;
  final List<Event>? deviceEvents;
  final bool? isCalendarEnabled;
  final Function(DateTime)? onDateSelected;
  final Function()? onAddNewJobSelected;
  final DateTime? selectedDate;
  final Function(Job)? onJobClicked;
  final Function(DateTime, bool)? onWeekChanged;
  final Function(bool)? onCalendarEnabled;

  WeeklyCalendarPageState({
    @required this.shouldClear,
    @required this.eventList,
    @required this.onDateSelected,
    @required this.selectedDate,
    @required this.onAddNewJobSelected,
    @required this.onJobClicked,
    @required this.jobs,
    @required this.deviceEvents,
    @required this.onWeekChanged,
    @required this.onCalendarEnabled,
    @required this.isCalendarEnabled,
  });

  WeeklyCalendarPageState copyWith({
    bool? shouldClear,
    List<EventDandyLight>? eventList,
    Function(DateTime)? onDateSelected,
    DateTime? selectedDate,
    List<Job>? jobs,
    List<Event>? deviceEvents,
    Function()? onAddNewJobSelected,
    Function(Job)? onJobClicked,
    Function(DateTime, bool)? onWeekChanged,
    Function(bool)? onCalendarEnabled,
    bool? isCalendarEnabled,
  }){
    return WeeklyCalendarPageState(
      shouldClear: shouldClear?? this.shouldClear,
      eventList: eventList?? this.eventList,
      onDateSelected: onDateSelected?? this.onDateSelected,
      selectedDate: selectedDate?? this.selectedDate,
      jobs: jobs ?? this.jobs,
      onAddNewJobSelected: onAddNewJobSelected?? this.onAddNewJobSelected,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      deviceEvents: deviceEvents ?? this.deviceEvents,
      onWeekChanged: onWeekChanged ?? this.onWeekChanged,
      onCalendarEnabled: onCalendarEnabled ?? this.onCalendarEnabled,
      isCalendarEnabled: isCalendarEnabled ?? this.isCalendarEnabled,
    );
  }

  factory WeeklyCalendarPageState.initial() => WeeklyCalendarPageState(
    shouldClear: true,
    eventList: [],
    jobs: [],
    onDateSelected: null,
    selectedDate: DateTime.now(),
    onAddNewJobSelected: null,
    onJobClicked: null,
    deviceEvents: [],
    onWeekChanged: null,
    onCalendarEnabled: null,
    isCalendarEnabled: false,
  );

  factory WeeklyCalendarPageState.fromStore(Store<AppState> store) {
    return WeeklyCalendarPageState(
      shouldClear: store.state.weeklyCalendarPageState!.shouldClear,
      eventList: store.state.weeklyCalendarPageState!.eventList,
      selectedDate: store.state.weeklyCalendarPageState!.selectedDate,
      jobs: store.state.weeklyCalendarPageState!.jobs,
      deviceEvents: store.state.weeklyCalendarPageState!.deviceEvents,
      isCalendarEnabled: store.state.weeklyCalendarPageState!.isCalendarEnabled,
      onAddNewJobSelected: () => store.dispatch(newJobActions.InitNewJobPageWithDateAction(store.state.newJobPageState!, store.state.weeklyCalendarPageState!.selectedDate!)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.weeklyCalendarPageState!, selectedDate)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState!, job.documentId!)),
      onWeekChanged: (focusedDay, isCalendarEnabled) => store.dispatch(FetchWeeklyDeviceEvents(store.state.weeklyCalendarPageState!, focusedDay, isCalendarEnabled)),
      onCalendarEnabled: (enabled) {
        store.dispatch(UpdateCalendarEnabledAction(store.state.weeklyCalendarPageState!, enabled));
        store.dispatch(FetchWeeklyDeviceEvents(store.state.weeklyCalendarPageState!, DateTime.now(), enabled));
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
      onWeekChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WeeklyCalendarPageState &&
              shouldClear == other.shouldClear &&
              eventList == other.eventList &&
              jobs == other.jobs &&
              onDateSelected == other.onDateSelected &&
              selectedDate == other.selectedDate &&
              deviceEvents == other.deviceEvents &&
              onWeekChanged == other.onWeekChanged &&
              onCalendarEnabled == other.onCalendarEnabled &&
              isCalendarEnabled == other.isCalendarEnabled &&
              onJobClicked == other.onJobClicked;
}