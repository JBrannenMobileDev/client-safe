import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';

final calendarPageReducer = combineReducers<CalendarPageState>([
  TypedReducer<CalendarPageState, SetJobsCalendarStateAction>(_setAllJobs),
  TypedReducer<CalendarPageState, SetDeviceEventsAction>(_setDeviceEvents),
  TypedReducer<CalendarPageState, SetSelectedDateAction>(_setSelectedDate),
]);

CalendarPageState _setDeviceEvents(CalendarPageState previousState, SetDeviceEventsAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in previousState.jobs) {
    eventList.add(EventDandyLight.fromJob(job));
  }


  for(Event event in action.deviceEvents) {

    eventList.add(EventDandyLight.fromDeviceEvent(event));
  }
  return previousState.copyWith(
    eventList: eventList,
    deviceEvents: action.deviceEvents,
  );
}

CalendarPageState _setAllJobs(CalendarPageState previousState, SetJobsCalendarStateAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in action.allJobs) {
    eventList.add(EventDandyLight.fromJob(job));
  }
  for(Event event in previousState.deviceEvents) {
    eventList.add(EventDandyLight.fromDeviceEvent(event));
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