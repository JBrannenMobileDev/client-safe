import 'package:dandylight/models/Job.dart';
import 'package:device_calendar/device_calendar.dart';
import 'WeeklyCalendarPageState.dart';

class SetSelectedDateAction{
  final WeeklyCalendarPageState pageState;
  final DateTime selectedDate;
  SetSelectedDateAction(this.pageState, this.selectedDate);
}

class SetJobsCalendarStateAction{
  final WeeklyCalendarPageState pageState;
  final List<Job> allJobs;
  SetJobsCalendarStateAction(this.pageState, this.allJobs);
}

class SetDeviceEventsAction {
  final WeeklyCalendarPageState pageState;
  final List<Event> deviceEvents;
  SetDeviceEventsAction(this.pageState, this.deviceEvents);
}

class FetchAllWeeklyCalendarJobsAction{
  final WeeklyCalendarPageState calendarPageState;
  FetchAllWeeklyCalendarJobsAction(this.calendarPageState);
}

class FetchWeeklyDeviceEvents{
  final WeeklyCalendarPageState calendarPageState;
  final DateTime focusedDay;
  final bool calendarEnabled;
  FetchWeeklyDeviceEvents(this.calendarPageState, this.focusedDay, this.calendarEnabled);
}

class UpdateCalendarEnabledAction{
  final WeeklyCalendarPageState pageState;
  final bool enabled;
  UpdateCalendarEnabledAction(this.pageState, this.enabled);
}
