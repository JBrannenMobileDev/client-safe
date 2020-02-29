import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart' as newJobActions;
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class CalendarPageState{
  final bool shouldClear;
  final Map<DateTime, List<Event>> eventMap;
  final List<Job> jobs;
  final Function(DateTime) onDateSelected;
  final Function() onAddNewJobSelected;
  final DateTime selectedDate;
  final Function(Job) onJobClicked;

  CalendarPageState({
    @required this.shouldClear,
    @required this.eventMap,
    @required this.onDateSelected,
    @required this.selectedDate,
    @required this.onAddNewJobSelected,
    @required this.onJobClicked,
    @required this.jobs,
  });

  CalendarPageState copyWith({
    bool shouldClear,
    Map<DateTime, List<Event>> eventMap,
    Function(DateTime) onDateSelected,
    DateTime selectedDate,
    List<Job> jobs,
    Function() onAddNewJobSelected,
    Function(Job) onJobClicked,
  }){
    return CalendarPageState(
      shouldClear: shouldClear?? this.shouldClear,
      eventMap: eventMap?? this.eventMap,
      onDateSelected: onDateSelected?? this.onDateSelected,
      selectedDate: selectedDate?? this.selectedDate,
      jobs: jobs ?? this.jobs,
      onAddNewJobSelected: onAddNewJobSelected?? this.onAddNewJobSelected,
      onJobClicked: onJobClicked ?? this.onJobClicked,
    );
  }

  factory CalendarPageState.initial() => CalendarPageState(
    shouldClear: true,
    eventMap: Map(),
    jobs: List(),
    onDateSelected: null,
    selectedDate: null,
    onAddNewJobSelected: null,
    onJobClicked: null,
  );

  factory CalendarPageState.fromStore(Store<AppState> store) {
    return CalendarPageState(
      shouldClear: store.state.calendarPageState.shouldClear,
      eventMap: store.state.calendarPageState.eventMap,
      selectedDate: store.state.calendarPageState.selectedDate,
      jobs: store.state.calendarPageState.jobs,
      onAddNewJobSelected: () => store.dispatch(newJobActions.InitNewJobPageWithDateAction(store.state.newJobPageState, store.state.calendarPageState.selectedDate)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.calendarPageState, selectedDate)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
    );
  }

  @override
  int get hashCode =>
      shouldClear.hashCode ^
      eventMap.hashCode ^
      jobs.hashCode ^
      onDateSelected.hashCode ^
      selectedDate.hashCode ^
      onJobClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CalendarPageState &&
              shouldClear == other.shouldClear &&
              eventMap == other.eventMap &&
              jobs == other.jobs &&
              onDateSelected == other.onDateSelected &&
              selectedDate == other.selectedDate &&
              onJobClicked == other.onJobClicked;
}