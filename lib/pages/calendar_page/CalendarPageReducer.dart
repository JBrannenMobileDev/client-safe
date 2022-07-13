import 'package:dandylight/models/Event.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:redux/redux.dart';

final calendarPageReducer = combineReducers<CalendarPageState>([
  TypedReducer<CalendarPageState, SetJobsCalendarStateAction>(_setAllJobs),
  TypedReducer<CalendarPageState, SetSelectedDateAction>(_setSelectedDate),
]);

CalendarPageState _setAllJobs(CalendarPageState previousState, SetJobsCalendarStateAction action) {
  List<Event> eventList = [];
  for(Job job in action.allJobs) {
    eventList.add(Event.fromJob(job));
  }
  return previousState.copyWith(
      eventList: eventList,
      jobs: action.allJobs,
  );
}

CalendarPageState _setSelectedDate(CalendarPageState previousState, SetSelectedDateAction action) {
  return previousState.copyWith(
      selectedDate: action.selectedDate,
  );
}