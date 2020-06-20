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
  Map<DateTime, List<Event>> eventMap = Map();
  for(Job job in action.allJobs) {
    if(job.selectedDate != null){
      if(eventMap.containsKey(job.selectedDate)){
        List<Event> eventList = eventMap.remove(job.selectedDate);
        eventList.add(Event.fromJob(job));
        eventMap.putIfAbsent(job.selectedDate, () => eventList);
      }else{
        List<Event> newEventList = List();
        newEventList.add(Event.fromJob(job));
        eventMap.putIfAbsent(job.selectedDate, () => newEventList);
      }
    }
  }
  return previousState.copyWith(
      eventMap: eventMap,
      jobs: action.allJobs,
  );
}

CalendarPageState _setSelectedDate(CalendarPageState previousState, SetSelectedDateAction action) {
  return previousState.copyWith(
      selectedDate: action.selectedDate,
  );
}