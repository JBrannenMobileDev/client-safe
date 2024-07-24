import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';
import '../../utils/TextFormatterUtil.dart';
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
  TypedReducer<NewJobPageState, SetSelectedSessionTypeAction>(_setJobType),
  TypedReducer<NewJobPageState, SetSunsetTimeAction>(_setSunsetTime),
  TypedReducer<NewJobPageState, SetSelectedStartTimeAction>(_setSelectedStartTime),
  TypedReducer<NewJobPageState, SetSelectedEndTimeAction>(_setSelectedEndTime),
  TypedReducer<NewJobPageState, InitializeNewContactPageAction>(_loadWithSelectedClient),
  TypedReducer<NewJobPageState, InitNewJobPageWithDateAction>(_loadWithSelectedDate),
  TypedReducer<NewJobPageState, SetDocumentPathAction>(_setDocumentPath),
  TypedReducer<NewJobPageState, UpdateComingFromClientDetails>(_updateComingFromClientDetails),
  TypedReducer<NewJobPageState, SetNewJobDeviceEventsAction>(_setNewJobDeviceEvents),
  TypedReducer<NewJobPageState, SetClientFirstNameAction>(_setClientFirstName),
  TypedReducer<NewJobPageState, SetOneTimePriceTextAction>(_setOneTimePrice),
  TypedReducer<NewJobPageState, SetInitialMapLatLng>(_setInitMapLatLng),
  TypedReducer<NewJobPageState, LoadAndSelectNewContactAction>(_setSelectedClientFromNewContactPage),
  TypedReducer<NewJobPageState, SetPriceProfilesAndSelectedAction>(setPricePackagesAndSelectedPackage),
  TypedReducer<NewJobPageState, SetJobTypeAndSelectedAction>(setJobTypeAndSelected),
  TypedReducer<NewJobPageState, SetProfileToNewJobAction>(setProfile),
  TypedReducer<NewJobPageState, FilterDeviceContactsNewJobAction>(filterContacts),
  TypedReducer<NewJobPageState, SetSelectedNewJobDeviceContactAction>(setSelectedDeviceContact),
  TypedReducer<NewJobPageState, SetDeviceContactsAction>(setDeviceContact),
  TypedReducer<NewJobPageState, SetLeadSourceAction>(setLeadSource),
  TypedReducer<NewJobPageState, SetDeviceClientFirstNameAction>(setDeviceContactFirstName),
]);

NewJobPageState setDeviceContactFirstName(NewJobPageState previousState, SetDeviceClientFirstNameAction action){
  return previousState.copyWith(
    deviceContactFirstName: action.firstName,
  );
}

NewJobPageState setLeadSource(NewJobPageState previousState, SetLeadSourceAction action){
  return previousState.copyWith(
      leadSource: action.sourceName,
  );
}

NewJobPageState setDeviceContact(NewJobPageState previousState, SetDeviceContactsAction action){
  return previousState.copyWith(
    deviceContacts: action.deviceContacts,
    filteredDeviceContacts: action.deviceContacts
  );
}

NewJobPageState filterContacts(NewJobPageState previousState, FilterDeviceContactsNewJobAction action) {
  List<Contact>? filteredClients = action.textInput!.isNotEmpty
      ? previousState.deviceContacts!
      .where((client) => client
      .displayName!
      .toLowerCase()
      .contains(action.textInput!.toLowerCase()))
      .toList()
      : previousState.deviceContacts;
  if(action.textInput!.isEmpty){
    filteredClients = previousState.deviceContacts;
  }
  return previousState.copyWith(
    filteredDeviceContacts: filteredClients,
    deviceSearchText: action.textInput,
  );
}

NewJobPageState setSelectedDeviceContact(NewJobPageState previousState, SetSelectedNewJobDeviceContactAction action){
  String? phone = action.selectedContact!.phones != null && action.selectedContact!.phones!.isNotEmpty ? action.selectedContact!.phones!.toList().elementAt(0).value : '';
  String? email = action.selectedContact!.emails != null && action.selectedContact!.emails!.isNotEmpty ? action.selectedContact!.emails!.toList().elementAt(0).value : '';
  phone = TextFormatterUtil.formatPhoneNum(phone);
  return previousState.copyWith(
    selectedDeviceContact: action.selectedContact,
    deviceContactFirstName: action.selectedContact!.givenName,
    deviceContactLastName: action.selectedContact!.familyName,
    deviceContactPhone: phone,
    deviceContactEmail: email,
  );
}

NewJobPageState setProfile(NewJobPageState previousState, SetProfileToNewJobAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

NewJobPageState setJobTypeAndSelected(NewJobPageState previousState, SetJobTypeAndSelectedAction action){
  return previousState.copyWith(
    sessionTypes: action.sessionTypes,
    selectedSessionType: action.sessionType,
    isSelectedSessionTypeNew: true,
    pageViewIndex: 2,
  );
}

NewJobPageState setPricePackagesAndSelectedPackage(NewJobPageState previousState, SetPriceProfilesAndSelectedAction action){
  return previousState.copyWith(
    oneTimePrice: '',
    pricingProfiles: action.priceProfiles,
    selectedPriceProfile: action.priceProfile,
    isSelectedPriceProfileNew: true,
    pageViewIndex: 3,
  );
}

NewJobPageState _setSelectedClientFromNewContactPage(NewJobPageState previousState, LoadAndSelectNewContactAction action){
  action.pageState!.allClients!.insert(0, action.selectedClient!);
  return previousState.copyWith(
    allClients: action.pageState!.allClients,
    clientSearchText: '',
    filteredClients: action.pageState!.allClients,
    selectedClient: action.selectedClient,
    isSelectedClientNew: true,
    pageViewIndex: 1,
  );
}

NewJobPageState _setInitMapLatLng(NewJobPageState previousState, SetInitialMapLatLng action){
  return previousState.copyWith(
    lat: action.lat,
    lon: action.lng,
  );
}

NewJobPageState _setOneTimePrice(NewJobPageState previousState, SetOneTimePriceTextAction action) {
  String numbersOnly = action.inputText!.replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '');
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
  for(Job job in previousState.jobs!) {
    eventList.add(EventDandyLight.fromJob(job));
  }
  for(Event event in action.deviceEvents!) {
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
      clientFirstName: action.client != null ? action.client!.firstName : '',
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
  DateTime selectedTime = action.sunset != null ? DateTime(
    action.sunset!.year,
    action.sunset!.month,
    action.sunset!.day,
    (action.sunset!.hour - 1),
    ((action.sunset!.minute / 10).floor() * 10),
  ) : DateTime.now();
  return previousState.copyWith(
      sunsetDateTime: action.sunset,
      initialTimeSelectorTime: selectedTime,
  );
}

NewJobPageState _setJobType(NewJobPageState previousState, SetSelectedSessionTypeAction action) {
  return previousState.copyWith(
      sessionType: action.sessionType,
      selectedSessionType: action.sessionType);
}

NewJobPageState _setSelectedPriceProfile(NewJobPageState previousState, SetSelectedPriceProfile action) {
  PriceProfile? newProfile;
  if(previousState.selectedPriceProfile != action.priceProfile) newProfile = action.priceProfile!;
  return previousState.copyWith(
      selectedPriceProfile: newProfile,
      oneTimePrice: '',
  );
}

NewJobPageState _setSelectedLocation(NewJobPageState previousState, SetSelectedLocation action) {
  LocationDandy? newLocation;
  if(previousState.selectedLocation != action.location) newLocation = action.location!;
  return previousState.copyWith(
      selectedLocation: newLocation,
      oneTimeLocation: null,
  );
}

NewJobPageState _setSelectedOneTimeLocation(NewJobPageState previousState, SetSelectedOneTimeLocation action) {
  List<LocationDandy> allLocations = action.pageState!.locations!;
  List<File?>? imageFiles = action.pageState!.imageFiles!;
  if(previousState.oneTimeLocation == null) {
    allLocations.insert(0, action.location!);
    imageFiles.insert(0, File(""));
  } else {
    allLocations.remove(previousState.oneTimeLocation);
    allLocations.insert(0, action.location!);
  }
  return previousState.copyWith(
      oneTimeLocation: action.location,
      selectedLocation: action.location,
      locations: allLocations,
      pageViewIndex: 4,

  );
}

NewJobPageState _updateErrorState(NewJobPageState previousState, UpdateErrorStateAction action) {
  return previousState.copyWith(errorState: action.errorCode);
}

NewJobPageState _incrementPageViewIndex(NewJobPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex!;
  incrementedIndex++;
  return previousState.copyWith(pageViewIndex: incrementedIndex);
}

NewJobPageState _decrementPageViewIndex(NewJobPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex!;
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
    sessionTypes: action.sessionTypes,
    imageFiles: action.imageFiles,
    filteredClients: action.allClients,
  );
}

NewJobPageState _setSelectedClient(NewJobPageState previousState, ClientSelectedAction action) {
  Client? selectedClient = previousState.selectedClient == action.client ? null : action.client;
  return previousState.copyWith(
    selectedClient: selectedClient,
    clientFirstName: selectedClient!.firstName,
    isSelectedClientNew: false,
  );
}

NewJobPageState _setClientFirstName(NewJobPageState previousState, SetClientFirstNameAction action) {
  List<Client> filteredClients = _filterClients(previousState, action.firstName!);
  return previousState.copyWith(
    selectedClient: null,
    clientFirstName: action.firstName,
    filteredClients: filteredClients,
  );
}

List<Client> _filterClients(NewJobPageState previousState, String firstName) {
  List<Client>? filteredClientsByFirstName = firstName.isNotEmpty
      ? previousState.allClients!
          .where((client) => client
              .getClientFullName()
              .toLowerCase()
              .contains(firstName.toLowerCase())
          ).toList()
      : previousState.allClients;
  return filteredClientsByFirstName!;
}
