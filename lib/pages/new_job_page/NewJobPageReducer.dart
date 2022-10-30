import 'dart:io';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';
import 'NewJobPageState.dart';

final newJobPageReducer = combineReducers<NewJobPageState>([
  TypedReducer<NewJobPageState, ClearStateAction>(_clearState),
  TypedReducer<NewJobPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewJobPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewJobPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewJobPageState, SetAllToStateAction>(_setAll),
  TypedReducer<NewJobPageState, ClientSelectedAction>(_setSelectedClient),
  TypedReducer<NewJobPageState, SetSelectedPriceProfile>(_setSelectedPriceProfile),
  TypedReducer<NewJobPageState, SetSelectedLocation>(_setSelectedLocation),
  TypedReducer<NewJobPageState, SetSelectedOneTimeLocation>(_setSelectedOneTimeLocation),
  TypedReducer<NewJobPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<NewJobPageState, SetSelectedJobTypeAction>(_setJobType),
  TypedReducer<NewJobPageState, SetSunsetTimeAction>(_setSunsetTime),
  TypedReducer<NewJobPageState, SetSelectedStartTimeAction>(_setSelectedStartTime),
  TypedReducer<NewJobPageState, SetSelectedEndTimeAction>(_setSelectedEndTime),
  TypedReducer<NewJobPageState, InitializeNewContactPageAction>(_loadWithSelectedClient),
  TypedReducer<NewJobPageState, InitNewJobPageWithDateAction>(_loadWithSelectedDate),
  TypedReducer<NewJobPageState, SetDocumentPathAction>(_setDocumentPath),
  TypedReducer<NewJobPageState, UpdateComingFromClientDetails>(_updateComingFromClientDetails),
  TypedReducer<NewJobPageState, SetNewJobDeviceEventsAction>(_setNewJobDeviceEvents),
  TypedReducer<NewJobPageState, SetClientFirstNameAction>(_setClientFirstName),
  TypedReducer<NewJobPageState, SetClientLastNameAction>(_setClientLastName),
  TypedReducer<NewJobPageState, SetOneTimePriceTextAction>(_setOneTimePrice),
  TypedReducer<NewJobPageState, SetInitialMapLatLng>(_setInitMapLatLng),

]);

NewJobPageState _setInitMapLatLng(NewJobPageState previousState, SetInitialMapLatLng action){
  return previousState.copyWith(
    lat: action.lat,
    lon: action.lng,
  );
}

NewJobPageState _setOneTimePrice(NewJobPageState previousState, SetOneTimePriceTextAction action) {
  String numbersOnly = action.inputText.replaceAll('\$', '').replaceAll(' ', '');
  if(numbersOnly == '0') {
    numbersOnly = '';
  }
  return previousState.copyWith(
      selectedPriceProfile: null,
      oneTimePrice: numbersOnly
  );
}

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

NewJobPageState _setDocumentPath(NewJobPageState previousState, SetDocumentPathAction action) {
  return previousState.copyWith(documentPath: action.documentPath);
}

NewJobPageState _setSelectedStartTime(NewJobPageState previousState, SetSelectedStartTimeAction action) {
  return previousState.copyWith(selectedStartTime: action.time);
}

NewJobPageState _setSelectedEndTime(NewJobPageState previousState, SetSelectedEndTimeAction action) {
  return previousState.copyWith(selectedEndTime: action.time);
}

NewJobPageState _loadWithSelectedClient(NewJobPageState previousState, InitializeNewContactPageAction action) {
  return previousState.copyWith(
      selectedClient: action.client,
      clientFirstName: action.client.firstName,
      clientLastName: action.client.lastName,
      shouldClear: false,
      comingFromClientDetails: true,
      pageViewIndex: 0,
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
  DateTime selectedTime = action.sunset != null ? DateTime(
    action.sunset.year,
    action.sunset.month,
    action.sunset.day,
    (action.sunset.hour - 1),
    ((action.sunset.minute / 10).floor() * 10),
  ) : DateTime.now();
  return previousState.copyWith(
      sunsetDateTime: action.sunset,
      initialTimeSelectorTime: selectedTime,
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
  return previousState.copyWith(
      selectedLocation: newLocation,
      oneTimeLocation: null,
  );
}

NewJobPageState _setSelectedOneTimeLocation(NewJobPageState previousState, SetSelectedOneTimeLocation action) {
  List<Location> allLocations = action.pageState.locations;
  List<File> imageFiles = action.pageState.imageFiles;
  if(previousState.oneTimeLocation == null) {
    allLocations.insert(0, action.location);
    imageFiles.insert(0, File(""));
  } else {
    allLocations.remove(previousState.oneTimeLocation);
    allLocations.insert(0, action.location);
  }
  return previousState.copyWith(
      oneTimeLocation: action.location,
      selectedLocation: action.location,
      locations: allLocations,
  );
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

NewJobPageState _setAll(NewJobPageState previousState, SetAllToStateAction action) {
  return previousState.copyWith(
    allClients: action.allClients,
    pricingProfiles: action.allPriceProfiles,
    locations: action.allLocations,
    isFinishedFetchingClients: true,
    jobs: action.upcomingJobs,
    jobTypes: action.jobTypes,
    imageFiles: action.imageFiles,
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
