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

class FetchAllCalendarJobsAction{
  final WeeklyCalendarPageState calendarPageState;
  FetchAllCalendarJobsAction(this.calendarPageState);
}

class FetchDeviceEvents{
  final WeeklyCalendarPageState calendarPageState;
  final DateTime month;
  final bool calendarEnabled;
  FetchDeviceEvents(this.calendarPageState, this.month, this.calendarEnabled);
}

class UpdateCalendarEnabledAction{
  final WeeklyCalendarPageState pageState;
  final bool enabled;
  UpdateCalendarEnabledAction(this.pageState, this.enabled);
}
