import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';

import 'CalendarSelectionPageState.dart';

final calendarSelectionPageReducer = combineReducers<CalendarSelectionPageState>([
  TypedReducer<CalendarSelectionPageState, SetWritableCalendars>(_setWritableCalendars),
  TypedReducer<CalendarSelectionPageState, UpdateSelectedCalendarsAction>(_updateSelectedCalendars),
]);

CalendarSelectionPageState _setWritableCalendars(CalendarSelectionPageState previousState, SetWritableCalendars action){
  return previousState.copyWith(
      writableCalendars: action.writableCalendars,
  );
}

CalendarSelectionPageState _updateSelectedCalendars(CalendarSelectionPageState previousState, UpdateSelectedCalendarsAction action){
  List<Calendar> updatedSelectedCalendars = previousState.selectedCalendars!;
  if(action.selected!) {
    updatedSelectedCalendars.add(action.selectedCalendar!);
  } else {
    updatedSelectedCalendars.remove(action.selectedCalendar);
  }
  return previousState.copyWith(
    selectedCalendars: updatedSelectedCalendars,
  );
}