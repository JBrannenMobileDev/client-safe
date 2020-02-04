import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:redux/redux.dart';
import 'NewJobPageState.dart';

final newJobPageReducer = combineReducers<NewJobPageState>([
  TypedReducer<NewJobPageState, ClearStateAction>(_clearState),
  TypedReducer<NewJobPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewJobPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewJobPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewJobPageState, SetAllToStateAction>(_setAllClients),
  TypedReducer<NewJobPageState, ClientSelectedAction>(_setSelectedClient),
  TypedReducer<NewJobPageState, FilterClientList>(_filterClients),
  TypedReducer<NewJobPageState, SetJobTitleAction>(_setJobTitle),
  TypedReducer<NewJobPageState, SetSelectedPriceProfile>(_setSelectedPriceProfile),
  TypedReducer<NewJobPageState, SetSelectedLocation>(_setSelectedLocation),
  TypedReducer<NewJobPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<NewJobPageState, SetSelectedJobStageAction>(_setJobStage),
  TypedReducer<NewJobPageState, SetSelectedJobTypeAction>(_setJobType),
  TypedReducer<NewJobPageState, SetSunsetTimeAction>(_setSunsetTime),
  TypedReducer<NewJobPageState, SetSelectedTimeAction>(_setSelectedTime),
  TypedReducer<NewJobPageState, InitializeNewContactPageAction>(_loadWithSelectedClient),
]);

NewJobPageState _setSelectedTime(NewJobPageState previousState, SetSelectedTimeAction action) {
  return previousState.copyWith(selectedTime: action.time);
}

NewJobPageState _loadWithSelectedClient(NewJobPageState previousState, InitializeNewContactPageAction action) {
  return previousState.copyWith(
      selectedClient: action.client,
      shouldClear: false,
  );
}

NewJobPageState _setSelectedDate(NewJobPageState previousState, SetSelectedDateAction action) {
  return previousState.copyWith(selectedDate: action.selectedDate);
}

NewJobPageState _setSunsetTime(NewJobPageState previousState, SetSunsetTimeAction action) {
  return previousState.copyWith(sunsetDateTime: action.sunset);
}

NewJobPageState _setJobStage(NewJobPageState previousState, SetSelectedJobStageAction action) {
  List<JobStage> selectedJobStagesUpdated = List();
  bool shouldKeep = true;
  for(JobStage stageFromList in previousState.selectedJobStages){
    if(stageFromList.stage == action.jobStage.stage){
      shouldKeep = false;
    }else{
      selectedJobStagesUpdated.add(stageFromList);
    }
  }
  if(shouldKeep) selectedJobStagesUpdated.add(action.jobStage);
  selectedJobStagesUpdated.sort((a, b) => a.value.compareTo(b.value));
  JobStage currentJobStage = selectedJobStagesUpdated.last;
  return previousState.copyWith(currentJobStage: currentJobStage, selectedJobStages: selectedJobStagesUpdated);
}

NewJobPageState _setJobType(NewJobPageState previousState, SetSelectedJobTypeAction action) {
  return previousState.copyWith(
      jobType: ImageUtil.getJobTypeText(action.jobType),
      jobTypeIcon: action.jobType);
}

NewJobPageState _setSelectedPriceProfile(NewJobPageState previousState, SetSelectedPriceProfile action) {
  PriceProfile newProfile;
  if(previousState.selectedPriceProfile != action.priceProfile) newProfile = action.priceProfile;
  return previousState.copyWith(selectedPriceProfile: newProfile);
}

NewJobPageState _setSelectedLocation(NewJobPageState previousState, SetSelectedLocation action) {
  Location newLocation;
  if(previousState.selectedLocation != action.location) newLocation = action.location;
  return previousState.copyWith(selectedLocation: newLocation);
}

NewJobPageState _setJobTitle(NewJobPageState previousState, SetJobTitleAction action) {
  return previousState.copyWith(jobTitle: action.jobTitle);
}

NewJobPageState _updateErrorState(NewJobPageState previousState, UpdateErrorStateAction action) {
  return previousState.copyWith(errorState: action.errorCode);
}

NewJobPageState _incrementPageViewIndex(NewJobPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(pageViewIndex: incrementedIndex);
}

NewJobPageState _decrementPageViewIndex(NewJobPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(pageViewIndex: decrementedIndex);
}

NewJobPageState _clearState(NewJobPageState previousState, ClearStateAction action) {
  return NewJobPageState.initial();
}

NewJobPageState _setAllClients(NewJobPageState previousState, SetAllToStateAction action) {
  Map<DateTime, List<Event>> eventMap = Map();
  for(Job job in action.upcomingJobs) {
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
  for(Event event in action.eventsFromDevice){
    if(eventMap.containsKey(event.selectedDate)){
      List<Event> eventList = eventMap.remove(event.selectedDate);
      eventList.add(event);
      eventMap.putIfAbsent(event.selectedDate, () => eventList);
    }else{
      List<Event> newEventList = List();
      newEventList.add(event);
      eventMap.putIfAbsent(event.selectedDate, () => newEventList);
    }
  }
  return previousState.copyWith(
    allClients: action.allClients,
    filteredClients: action.allClients,
    pricingProfiles: action.allPriceProfiles,
    locations: action.allLocations,
    upcomingJobs: action.upcomingJobs,
    isFinishedFetchingClients: true,
    eventMap: eventMap,
  );
}

NewJobPageState _setSelectedClient(NewJobPageState previousState, ClientSelectedAction action) {
  Client selectedClient =
      previousState.selectedClient == action.client ? null : action.client;
  return previousState.copyWith(
    selectedClient: selectedClient,
  );
}

NewJobPageState _filterClients(NewJobPageState previousState, FilterClientList action) {
  List<Client> filteredClients = action.textInput.length > 0
      ? previousState.allClients
          .where((client) => client
              .getClientFullName()
              .toLowerCase()
              .contains(action.textInput.toLowerCase()))
          .toList()
      : previousState.allClients;
  return previousState.copyWith(
    filteredClients: filteredClients,
  );
}
