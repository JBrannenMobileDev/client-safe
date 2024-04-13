import 'package:dandylight/AppState.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'CalendarSelectionActions.dart';

class CalendarSelectionPageState {
  final List<Calendar>? selectedCalendars;
  final List<Calendar>? writableCalendars;
  final Function(Calendar, bool)? onCalendarSelected;
  final Function()? fetchWritableCalendars;
  final Function()? onSaveSelected;
  final Function()? onCancelSelected;

  CalendarSelectionPageState({
    @required this.onCalendarSelected,
    @required this.fetchWritableCalendars,
    @required this.selectedCalendars,
    @required this.writableCalendars,
    @required this.onSaveSelected,
    @required this.onCancelSelected,
  });

  CalendarSelectionPageState copyWith({
    List<Calendar>? selectedCalendars,
    List<Calendar>? writableCalendars,
    Function(Calendar, bool)? onCalendarSelected,
    Function()? fetchWritableCalendars,
    Function()? onSaveSelected,
    Function()? onCancelSelected,
  }){
    return CalendarSelectionPageState(
      selectedCalendars: selectedCalendars?? this.selectedCalendars,
      fetchWritableCalendars: fetchWritableCalendars?? this.fetchWritableCalendars,
      writableCalendars: writableCalendars?? this.writableCalendars,
      onCalendarSelected: onCalendarSelected?? this.onCalendarSelected,
      onSaveSelected: onSaveSelected?? this.onSaveSelected,
      onCancelSelected: onCancelSelected ?? this.onCancelSelected,
    );
  }

  factory CalendarSelectionPageState.initial() => CalendarSelectionPageState(
    selectedCalendars: [],
    writableCalendars: [],
    onCalendarSelected: null,
    onSaveSelected: null,
    fetchWritableCalendars: null,
    onCancelSelected: null,
  );

  factory CalendarSelectionPageState.fromStore(Store<AppState> store) {
    return CalendarSelectionPageState(
      selectedCalendars: store.state.calendarSelectionPageState!.selectedCalendars,
      writableCalendars: store.state.calendarSelectionPageState!.writableCalendars,
      onCalendarSelected: (calendar, isSelected) => store.dispatch(UpdateSelectedCalendarsAction(store.state.calendarSelectionPageState, calendar, isSelected)),
      onSaveSelected: () => store.dispatch(SaveSelectedAction(store.state.calendarSelectionPageState)),
      fetchWritableCalendars: () => store.dispatch(FetchWritableCalendars(store.state.calendarSelectionPageState)),
      onCancelSelected: () => store.dispatch(SetCalendarPermissionFalse(store.state.calendarSelectionPageState)),
    );
  }

  @override
  int get hashCode =>
    fetchWritableCalendars.hashCode ^
    onSaveSelected.hashCode ^
    onCalendarSelected.hashCode ^
    selectedCalendars.hashCode ^
    onCancelSelected.hashCode ^
    writableCalendars.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarSelectionPageState &&
          fetchWritableCalendars == other.fetchWritableCalendars &&
          onSaveSelected == other.onSaveSelected &&
          onCalendarSelected == other.onCalendarSelected &&
          selectedCalendars == other.selectedCalendars &&
          onCancelSelected == other.onCancelSelected &&
          writableCalendars == other.writableCalendars;
}
