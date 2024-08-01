import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:device_calendar/device_calendar.dart';

class SetSelectedDateAction{
  final CalendarPageState pageState;
  final DateTime selectedDate;
  SetSelectedDateAction(this.pageState, this.selectedDate);
}

class SetJobsCalendarStateAction{
  final CalendarPageState pageState;
  final List<Job> allJobs;
  SetJobsCalendarStateAction(this.pageState, this.allJobs);
}

class SetDeviceEventsAction {
  final CalendarPageState pageState;
  final List<Event> deviceEvents;
  SetDeviceEventsAction(this.pageState, this.deviceEvents);
}

class FetchAllWeeklyCalendarJobsAction{
  final CalendarPageState calendarPageState;
  FetchAllWeeklyCalendarJobsAction(this.calendarPageState);
}

class FetchWeeklyDeviceEvents{
  final CalendarPageState calendarPageState;
  final DateTime month;
  final bool calendarEnabled;
  FetchWeeklyDeviceEvents(this.calendarPageState, this.month, this.calendarEnabled);
}

class UpdateCalendarEnabledAction{
  final CalendarPageState pageState;
  final bool enabled;
  UpdateCalendarEnabledAction(this.pageState, this.enabled);
}
