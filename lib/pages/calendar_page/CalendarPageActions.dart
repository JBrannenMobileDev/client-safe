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

class SetDeviceCalendarsAction {
  final CalendarPageState pageState;
  final List<Calendar> deviceCalendars;
  SetDeviceCalendarsAction(this.pageState, this.deviceCalendars);
}

class FetchAllJobsAction{
  final CalendarPageState calendarPageState;
  FetchAllJobsAction(this.calendarPageState);
}

class FetchDeviceCalendars{
  final CalendarPageState calendarPageState;
  FetchDeviceCalendars(this.calendarPageState);
}
