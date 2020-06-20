import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';

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

class FetchAllJobsAction{
  final CalendarPageState calendarPageState;
  FetchAllJobsAction(this.calendarPageState);
}
