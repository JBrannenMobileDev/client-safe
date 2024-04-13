import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageState.dart';
import 'package:device_calendar/device_calendar.dart';

class ClientSelectedAction{
  final CalendarSelectionPageState? pageState;
  ClientSelectedAction(this.pageState);
}

class UpdateSelectedCalendarsAction{
  final CalendarSelectionPageState? pageState;
  final Calendar? selectedCalendar;
  final bool? selected;
  UpdateSelectedCalendarsAction(this.pageState, this.selectedCalendar, this.selected);
}

class SaveSelectedAction{
  final CalendarSelectionPageState? pageState;
  SaveSelectedAction(this.pageState);
}

class FetchWritableCalendars{
  final CalendarSelectionPageState? pageState;
  FetchWritableCalendars(this.pageState);
}

class SetCalendarPermissionFalse{
  final CalendarSelectionPageState? pageState;
  SetCalendarPermissionFalse(this.pageState);
}

class SetWritableCalendars{
  final CalendarSelectionPageState? pageState;
  final List<Calendar>? writableCalendars;
  SetWritableCalendars(this.pageState, this.writableCalendars);
}