import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';
import '../../models/ReminderDandyLight.dart';
import 'NewJobPageState.dart';

final newJobPageReducer = combineReducers<NewJobPageState>([
  TypedReducer<NewJobPageState, ClearStateAction>(_clearState),
  TypedReducer<NewJobPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewJobPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewJobPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewJobPageState, SetAllToStateAction>(_setAllClients),
  TypedReducer<NewJobPageState, ClientSelectedAction>(_setSelectedClient),
  TypedReducer<NewJobPageState, SetJobTitleAction>(_setJobTitle),
  TypedReducer<NewJobPageState, SetSelectedPriceProfile>(_setSelectedPriceProfile),
  TypedReducer<NewJobPageState, SetSelectedLocation>(_setSelectedLocation),
  TypedReducer<NewJobPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<NewJobPageState, SetSelectedJobStageAction>(_setJobStage),
  TypedReducer<NewJobPageState, SetSelectedJobReminderAction>(_setReminder),
  TypedReducer<NewJobPageState, SetAllRemindersAction>(_setAllReminders),
  TypedReducer<NewJobPageState, SetDefaultRemindersAction>(_setDefaultReminders),
  TypedReducer<NewJobPageState, SetSelectedJobTypeAction>(_setJobType),
  TypedReducer<NewJobPageState, SetSunsetTimeAction>(_setSunsetTime),
  TypedReducer<NewJobPageState, SetSelectedTimeAction>(_setSelectedTime),
  TypedReducer<NewJobPageState, InitializeNewContactPageAction>(_loadWithSelectedClient),
  TypedReducer<NewJobPageState, InitNewJobPageWithDateAction>(_loadWithSelectedDate),
  TypedReducer<NewJobPageState, AddToDepositAmountAction>(_updateDepositAmount),
  TypedReducer<NewJobPageState, ClearDepositAction>(_clearDeposit),
  TypedReducer<NewJobPageState, SetDocumentPathAction>(_setDocumentPath),
  TypedReducer<NewJobPageState, UpdateComingFromClientDetails>(_updateComingFromClientDetails),
  TypedReducer<NewJobPageState, SetNewJobDeviceEventsAction>(_setNewJobDeviceEvents),
  TypedReducer<NewJobPageState, SetClientFirstNameAction>(_setClientFirstName),
  TypedReducer<NewJobPageState, SetClientLastNameAction>(_setClientLastName),
]);

NewJobPageState _updateComingFromClientDetails(NewJobPageState previousState, UpdateComingFromClientDetails action) {
  return previousState.copyWith(comingFromClientDetails: action.isComingFromClientDetails);
}

NewJobPageState _setNewJobDeviceEvents(NewJobPageState previousState, SetNewJobDeviceEventsAction action) {
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

NewJobPageState _setAllReminders(NewJobPageState previousState, SetAllRemindersAction action) {
  List<ReminderDandyLight> sortedReminders = action.reminders;
  sortedReminders.sort((a, b) => (a.isDefault ? 0 : 1) < (b.isDefault ? 0 : 1) ? 0 : 1);
  return previousState.copyWith(allReminders: sortedReminders);
}

NewJobPageState _setDefaultReminders(NewJobPageState previousState, SetDefaultRemindersAction action) {
  return previousState.copyWith(selectedReminders: action.defaultReminders);
}

NewJobPageState _setDocumentPath(NewJobPageState previousState, SetDocumentPathAction action) {
  return previousState.copyWith(documentPath: action.documentPath);
}

NewJobPageState _clearDeposit(NewJobPageState previousState, ClearDepositAction action) {
  return previousState.copyWith(depositAmount: 0);
}

NewJobPageState _updateDepositAmount(NewJobPageState previousState, AddToDepositAmountAction action) {
  int newAmount = previousState.depositAmount + action.amountToAdd;
  return previousState.copyWith(depositAmount: newAmount);
}

NewJobPageState _setSelectedTime(NewJobPageState previousState, SetSelectedTimeAction action) {
  return previousState.copyWith(selectedTime: action.time);
}

NewJobPageState _loadWithSelectedClient(NewJobPageState previousState, InitializeNewContactPageAction action) {
  return previousState.copyWith(
      selectedClient: action.client,
      shouldClear: false,
      comingFromClientDetails: true,
      pageViewIndex: 1,
  );
}

NewJobPageState _loadWithSelectedDate(NewJobPageState previousState, InitNewJobPageWithDateAction action) {
  return NewJobPageState.initial().copyWith(
    selectedDate: action.selectedDate,
    shouldClear: true,
  );
}

NewJobPageState _setSelectedDate(NewJobPageState previousState, SetSelectedDateAction action) {
  return previousState.copyWith(selectedDate: action.selectedDate);
}

NewJobPageState _setSunsetTime(NewJobPageState previousState, SetSunsetTimeAction action) {
  return previousState.copyWith(sunsetDateTime: action.sunset);
}

NewJobPageState _setJobStage(NewJobPageState previousState, SetSelectedJobStageAction action) {
  List<JobStage> selectedJobStagesUpdated = [];
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
  JobStage currentJobStage = JobStage.getNextStage(selectedJobStagesUpdated.last);
  return previousState.copyWith(currentJobStage: currentJobStage, selectedJobStages: selectedJobStagesUpdated);
}

NewJobPageState _setReminder(NewJobPageState previousState, SetSelectedJobReminderAction action) {
  List<ReminderDandyLight> selectedJobReminderUpdated = [];
  bool shouldKeep = true;
  for(ReminderDandyLight selectedReminder in previousState.selectedReminders){
    if(selectedReminder.description == action.reminder.description){
      shouldKeep = false;
    }else{
      selectedJobReminderUpdated.add(selectedReminder);
    }
  }
  if(shouldKeep) selectedJobReminderUpdated.add(action.reminder);
  selectedJobReminderUpdated.sort((a, b) => a.description.compareTo(b.description));
  return previousState.copyWith(
      selectedReminders: selectedJobReminderUpdated
  );
}

NewJobPageState _setJobType(NewJobPageState previousState, SetSelectedJobTypeAction action) {
  return previousState.copyWith(
      jobType: action.jobType,
      selectedJobType: action.jobType);
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
  return previousState.copyWith(
    allClients: action.allClients,
    pricingProfiles: action.allPriceProfiles,
    locations: action.allLocations,
    upcomingJobs: action.upcomingJobs,
    isFinishedFetchingClients: true,
    jobs: action.upcomingJobs,
    selectedPriceProfile: action.allPriceProfiles.length > 0 ? action.allPriceProfiles.elementAt(0) : null,
  );
}

NewJobPageState _setSelectedClient(NewJobPageState previousState, ClientSelectedAction action) {
  Client selectedClient = previousState.selectedClient == action.client ? null : action.client;
  return previousState.copyWith(
    selectedClient: selectedClient,
    clientFirstName: selectedClient.firstName,
    clientLastName: selectedClient.lastName,
  );
}

NewJobPageState _setClientFirstName(NewJobPageState previousState, SetClientFirstNameAction action) {
  List<Client> filteredClients = _filterClients(previousState, action.firstName, previousState.clientLastName);
  return previousState.copyWith(
    selectedClient: null,
    clientFirstName: action.firstName,
    filteredClients: filteredClients,
  );
}

NewJobPageState _setClientLastName(NewJobPageState previousState, SetClientLastNameAction action) {
  List<Client> filteredClients = _filterClients(previousState, previousState.clientFirstName, action.lastName);
  return previousState.copyWith(
    selectedClient: null,
    clientLastName: action.lastName,
    filteredClients: filteredClients,
  );
}

List<Client> _filterClients(NewJobPageState previousState, String firstName, String lastName) {
  List<Client> filteredClientsByFirstName = firstName.isNotEmpty
      ? previousState.allClients
          .where((client) => client
              .getClientFullName()
              .toLowerCase()
              .contains(firstName.toLowerCase())
          ).toList()
      : [];

  List<Client> filteredClientsByLastName = lastName.isNotEmpty
      ? previousState.allClients
      .where((client) => client
      .getClientFullName()
      .toLowerCase()
      .contains(lastName.toLowerCase())
  ).toList()
      : [];

  List<Client> result = [];

  for(Client clientByFirst in filteredClientsByFirstName) {
    if(!filteredClientsByLastName.contains(clientByFirst)) {
      result.add(clientByFirst);
    }
  }
  result.addAll(filteredClientsByLastName);

  return result;
}
