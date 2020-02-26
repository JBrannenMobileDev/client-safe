import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:redux/redux.dart';

final jobDetailsReducer = combineReducers<JobDetailsPageState>([
  TypedReducer<JobDetailsPageState, SetJobInfo>(_setJobInfo),
  TypedReducer<JobDetailsPageState, SaveStageCompleted>(_saveStageCompleted),
  TypedReducer<JobDetailsPageState, SetNewStagAnimationIndex>(_setNewStagAnimationIndex),
  TypedReducer<JobDetailsPageState, SetExpandedIndexAction>(_setExpandedIndex),
  TypedReducer<JobDetailsPageState, RemoveExpandedIndexAction>(_removeExpandedIndex),
  TypedReducer<JobDetailsPageState, SetClientAction>(_setClient),
  TypedReducer<JobDetailsPageState, SetSunsetTimeForJobAction>(_setSunsetTime),
  TypedReducer<JobDetailsPageState, UpdateScrollOffset>(_updateScrollOffset),
  TypedReducer<JobDetailsPageState, SaveUpdatedJobAction>(_updateJob),
  TypedReducer<JobDetailsPageState, SetEventMapAction>(_setEventMap),
]);

JobDetailsPageState _setEventMap(JobDetailsPageState previousState, SetEventMapAction action) {
  Map<DateTime, List<Event>> eventMap = Map();
  for(Job job in action.upcomingJobs) {
    if(job.selectedDate != null) {
      if (eventMap.containsKey(job.selectedDate)) {
        List<Event> eventList = eventMap.remove(job.selectedDate);
        eventList.add(Event.fromJob(job));
        eventMap.putIfAbsent(job.selectedDate, () => eventList);
      } else {
        List<Event> newEventList = List();
        newEventList.add(Event.fromJob(job));
        eventMap.putIfAbsent(job.selectedDate, () => newEventList);
      }
    }
  }
  return previousState.copyWith(
    eventMap: eventMap,
  );
}

JobDetailsPageState _updateJob(JobDetailsPageState previousState, SaveUpdatedJobAction action){
  return previousState.copyWith(
    job: action.job,
  );
}

JobDetailsPageState _setSunsetTime(JobDetailsPageState previousState, SetSunsetTimeForJobAction action){
  return previousState.copyWith(
    sunsetTime: action.sunset,
  );
}

JobDetailsPageState _updateScrollOffset(JobDetailsPageState previousState, UpdateScrollOffset action){
  return previousState.copyWith(
    stageScrollOffset: action.offset,
  );
}

JobDetailsPageState _setJobInfo(JobDetailsPageState previousState, SetJobInfo action){
  action.job.completedStages.sort((a, b) => a.value.compareTo(b.value));
  return previousState.copyWith(
    job: action.job,
  );
}

JobDetailsPageState _setClient(JobDetailsPageState previousState, SetClientAction action){
  return previousState.copyWith(
    client: action.client,
  );
}

JobDetailsPageState _saveStageCompleted(JobDetailsPageState previousState, SaveStageCompleted action){
  return previousState.copyWith(
    job: previousState.job,
  );
}
JobDetailsPageState _setNewStagAnimationIndex(JobDetailsPageState previousState, SetNewStagAnimationIndex action){
  return previousState.copyWith(newStagAnimationIndex: action.newStagAnimationIndex,
  );
}

JobDetailsPageState _setExpandedIndex(JobDetailsPageState previousState, SetExpandedIndexAction action){
  previousState.expandedIndexes.add(action.index);
  return previousState.copyWith(expandedIndexes: previousState.expandedIndexes,
  );
}

JobDetailsPageState _removeExpandedIndex(JobDetailsPageState previousState, RemoveExpandedIndexAction action){
  previousState.expandedIndexes.remove(action.index);
  return previousState.copyWith(expandedIndexes: previousState.expandedIndexes,
  );
}