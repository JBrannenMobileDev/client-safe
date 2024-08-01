import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';

import 'WeeklyCalendarPageActions.dart';
import 'WeeklyCalendarPageState.dart';

final weeklyCalendarPageReducer = combineReducers<WeeklyCalendarPageState>([
  TypedReducer<WeeklyCalendarPageState, SetJobsCalendarStateAction>(_setAllJobs),
  TypedReducer<WeeklyCalendarPageState, SetDeviceEventsAction>(_setDeviceEvents),
  TypedReducer<WeeklyCalendarPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<WeeklyCalendarPageState, UpdateCalendarEnabledAction>(_setCalendarEnabled),
]);

WeeklyCalendarPageState _setCalendarEnabled(WeeklyCalendarPageState previousState, UpdateCalendarEnabledAction action) {
  return previousState.copyWith(
    isCalendarEnabled: action.enabled,
  );
}

WeeklyCalendarPageState _setDeviceEvents(WeeklyCalendarPageState previousState, SetDeviceEventsAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in previousState.jobs!) {
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

WeeklyCalendarPageState _setAllJobs(WeeklyCalendarPageState previousState, SetJobsCalendarStateAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in action.allJobs) {
    eventList.add(EventDandyLight.fromJob(job));
  }
  for(Event event in previousState.deviceEvents!) {
    eventList.add(EventDandyLight.fromDeviceEvent(event));
  }
  return previousState.copyWith(
      eventList: eventList,
      jobs: action.allJobs,
  );
}

WeeklyCalendarPageState _setSelectedDate(WeeklyCalendarPageState previousState, SetSelectedDateAction action) {
  return previousState.copyWith(
      selectedDate: action.selectedDate,
  );
}