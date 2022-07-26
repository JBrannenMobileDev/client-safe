import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:redux/redux.dart';

final calendarPageReducer = combineReducers<CalendarPageState>([
  TypedReducer<CalendarPageState, SetJobsCalendarStateAction>(_setAllJobs),
  TypedReducer<CalendarPageState, SetDeviceCalendarsAction>(_setDeviceCalendars),
  TypedReducer<CalendarPageState, SetSelectedDateAction>(_setSelectedDate),
]);

CalendarPageState _setDeviceCalendars(CalendarPageState previousState, SetDeviceCalendarsAction action) {
  return previousState.copyWith(
    deviceCalendars: action.deviceCalendars,
  );
}

CalendarPageState _setAllJobs(CalendarPageState previousState, SetJobsCalendarStateAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in action.allJobs) {
    eventList.add(EventDandyLight.fromJob(job));
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