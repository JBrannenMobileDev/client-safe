import 'package:client_safe/models/Event.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart' as newJobActions;
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class CalendarPageState{
  final bool shouldClear;
  final Map<DateTime, List<Event>> eventMap;
  final Function(DateTime) onDateSelected;
  final Function() onAddNewJobSelected;
  final DateTime selectedDate;

  CalendarPageState({
    @required this.shouldClear,
    @required this.eventMap,
    @required this.onDateSelected,
    @required this.selectedDate,
    @required this.onAddNewJobSelected,
  });

  CalendarPageState copyWith({
    bool shouldClear,
    Map<DateTime, List<Event>> eventMap,
    Function(DateTime) onDateSelected,
    DateTime selectedDate,
    Function() onAddNewJobSelected,
  }){
    return CalendarPageState(
      shouldClear: shouldClear?? this.shouldClear,
      eventMap: eventMap?? this.eventMap,
      onDateSelected: onDateSelected?? this.onDateSelected,
      selectedDate: selectedDate?? this.selectedDate,
      onAddNewJobSelected: onAddNewJobSelected?? this.onAddNewJobSelected,
    );
  }

  factory CalendarPageState.initial() => CalendarPageState(
    shouldClear: true,
    eventMap: Map(),
    onDateSelected: null,
    selectedDate: null,
    onAddNewJobSelected: null,
  );

  factory CalendarPageState.fromStore(Store<AppState> store) {
    return CalendarPageState(
      shouldClear: store.state.calendarPageState.shouldClear,
      eventMap: store.state.calendarPageState.eventMap,
      selectedDate: store.state.calendarPageState.selectedDate,
      onAddNewJobSelected: () => store.dispatch(newJobActions.InitNewJobPageWithDateAction(store.state.newJobPageState, store.state.calendarPageState.selectedDate)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.calendarPageState, selectedDate)),
      );
  }

  @override
  int get hashCode =>
      shouldClear.hashCode ^
      eventMap.hashCode ^
      onDateSelected.hashCode ^
      selectedDate.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CalendarPageState &&
              shouldClear == other.shouldClear &&
              eventMap == other.eventMap &&
              onDateSelected == other.onDateSelected &&
              selectedDate == other.selectedDate;
}