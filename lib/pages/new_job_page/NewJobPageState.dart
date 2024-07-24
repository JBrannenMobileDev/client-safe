import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/Profile.dart';
import '../../models/SessionType.dart';
import '../sunset_weather_page/SunsetWeatherPageActions.dart' as sunsetPageActions;

@immutable
class NewJobPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";

  final int? id;
  final String? documentId;
  final int? pageViewIndex;
  final bool? saveButtonEnabled;
  final bool? shouldClear;
  final bool? comingFromClientDetails;
  final bool? isFinishedFetchingClients;
  final bool? isSelectedClientNew;
  final bool? isSelectedPriceProfileNew;
  final bool? isSelectedSessionTypeNew;
  final String? errorState;
  final Client? selectedClient;
  final String? clientFirstName;
  final String? deviceContactFirstName;
  final String? deviceContactLastName;
  final String? deviceContactPhone;
  final String? deviceContactEmail;
  final String? clientSearchText;
  final String? documentPath;
  final String? oneTimePrice;
  final String? leadSource;
  final String? instagramUrl;
  final Function(String)? onLeadSourceSelected;
  final PriceProfile? selectedPriceProfile;
  final Profile? profile;
  final LocationDandy? selectedLocation;
  final LocationDandy? oneTimeLocation;
  final DateTime? selectedDate;
  final DateTime? selectedStartTime;
  final DateTime? selectedEndTime;
  final DateTime? sunsetDateTime;
  final DateTime? initialTimeSelectorTime;
  final JobStage? currentJobStage;
  final SessionType? selectedSessionType;
  final List<Client>? allClients;
  final List<Client>? filteredClients;
  final List<PriceProfile>? pricingProfiles;
  final List<LocationDandy>? locations;
  final List<File?>? imageFiles;
  final List<EventDandyLight>? eventList;
  final List<Event>? deviceEvents;
  final List<Job>? jobs;
  final List<SessionType>? sessionTypes;
  final List<Contact>? deviceContacts;
  final List<Contact>? filteredDeviceContacts;
  final Contact? selectedDeviceContact;
  final String? deviceSearchText;
  final Function()? onSavePressed;
  final Function()? onCancelPressed;
  final Function()? onNextPressed;
  final Function()? onBackPressed;
  final Function(Client)? onClientSelected;
  final Function(String)? onClientFirstNameTextChanged;
  final Function(String)? onClientLastNameTextChanged;
  final Function(String)? onClientPhoneTextChanged;
  final Function(String)? onClientEmailTextChanged;
  final Function(String)? onClientInstagramUrlTextChanged;
  final Function()? onClearInputSelected;
  final Function(PriceProfile)? onPriceProfileSelected;
  final Function(LocationDandy)? onLocationSelected;
  final Function(DateTime)? onDateSelected;
  final Function(SessionType)? onSessionTypeSelected;
  final Function(DateTime)? onStartTimeSelected;
  final Function(DateTime)? onEndTimeSelected;
  final Function(DateTime)? onMonthChanged;
  final Function()? onSunsetWeatherSelected;
  final Function(String)? onOneTimePriceChanged;
  final Function(LocationDandy)? onLocationSearchResultSelected;
  final double? lat;
  final double? lon;
  final Function(bool)? onCalendarEnabled;
  final Function()? onSkipSelected;
  final Function(Contact)? onDeviceContactSelected;
  final Function(String)? onContactSearchTextChanged;
  final Function(String)? onDeviceContactFirstNameChanged;
  final Function(String)? onCustomLeadSourceTextChanged;
  final String? customLeadSourceName;

  NewJobPageState({
    @required this.id,
    @required this.documentId,
    @required this.comingFromClientDetails,
    @required this.documentPath,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.isFinishedFetchingClients,
    @required this.errorState,
    @required this.clientSearchText,
    @required this.selectedPriceProfile,
    @required this.selectedLocation,
    @required this.selectedDate,
    @required this.selectedStartTime,
    @required this.sunsetDateTime,
    @required this.selectedSessionType,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.selectedClient,
    @required this.onClientSelected,
    @required this.onClearInputSelected,
    @required this.allClients,
    @required this.filteredClients,
    @required this.pricingProfiles,
    @required this.onPriceProfileSelected,
    @required this.locations,
    @required this.eventList,
    @required this.jobs,
    @required this.onLocationSelected,
    @required this.onDateSelected,
    @required this.onSessionTypeSelected,
    @required this.currentJobStage,
    @required this.onStartTimeSelected,
    @required this.sessionTypes,
    @required this.onMonthChanged,
    @required this.deviceEvents,
    @required this.clientFirstName,
    @required this.onClientFirstNameTextChanged,
    @required this.imageFiles,
    @required this.onSunsetWeatherSelected,
    @required this.initialTimeSelectorTime,
    @required this.onOneTimePriceChanged,
    @required this.oneTimePrice,
    @required this.onEndTimeSelected,
    @required this.selectedEndTime,
    @required this.onLocationSearchResultSelected,
    @required this.lat,
    @required this.lon,
    @required this.oneTimeLocation,
    @required this.isSelectedClientNew,
    @required this.onCalendarEnabled,
    @required this.isSelectedPriceProfileNew,
    @required this.isSelectedSessionTypeNew,
    @required this.profile,
    @required this.onSkipSelected,
    @required this.onClientLastNameTextChanged,
    @required this.onClientPhoneTextChanged,
    @required this.onClientEmailTextChanged,
    @required this.onClientInstagramUrlTextChanged,
    @required this.filteredDeviceContacts,
    @required this.selectedDeviceContact,
    @required this.deviceContacts,
    @required this.deviceSearchText,
    @required this.onDeviceContactSelected,
    @required this.onContactSearchTextChanged,
    @required this.deviceContactEmail,
    @required this.deviceContactFirstName,
    @required this.deviceContactLastName,
    @required this.deviceContactPhone,
    @required this.leadSource,
    @required this.onLeadSourceSelected,
    @required this.onDeviceContactFirstNameChanged,
    @required this.instagramUrl,
    @required this.customLeadSourceName,
    @required this.onCustomLeadSourceTextChanged,
  });

  NewJobPageState copyWith({
    int? id,
    String? documentId,
    String? documentPath,
    int? pageViewIndex,
    bool? comingFromClientDetails,
    bool? saveButtonEnabled,
    bool? shouldClear,
    bool? isFinishedFetchingClients,
    bool? isSelectedClientNew,
    bool? isSelectedPriceProfileNew,
    bool? isSelectedSessionTypeNew,
    String? errorState,
    Client? selectedClient,
    String? clientFirstName,
    String? clientSearchText,
    String? deviceContactFirstName,
    String? deviceContactLastName,
    String? deviceContactPhone,
    String? deviceContactEmail,
    PriceProfile? selectedPriceProfile,
    LocationDandy? selectedLocation,
    List<Client>? allClients,
    List<Client>? filteredClients,
    List<PriceProfile>? pricingProfiles,
    List<LocationDandy>? locations,
    List<File?>? imageFiles,
    Profile? profile,
    String? instagramUrl,
    DateTime? selectedDate,
    DateTime? selectedStartTime,
    DateTime? selectedEndTime,
    DateTime? sunsetDateTime,
    DateTime? initialTimeSelectorTime,
    SessionType? sessionType,
    SessionType? selectedSessionType,
    List<EventDandyLight>? eventList,
    List<Event>? deviceEvents,
    List<Job>? jobs,
    List<SessionType>? sessionTypes,
    String? leadSource,
    String? customLeadSourceName,
    Function(String)? onCustomLeadSourceTextChanged,
    Function(String)? onLeadSourceSelected,
    Function()? onSavePressed,
    Function()? onCancelPressed,
    Function()? onNextPressed,
    Function()? onBackPressed,
    Function(Client)? onClientSelected,
    Function()? onClearInputSelected,
    Function(PriceProfile)? onPriceProfileSelected,
    Function(LocationDandy)? onLocationSelected,
    Function(DateTime)? onDateSelected,
    Function(SessionType)? onSessionTypeSelected,
    Function(DateTime)? onStartTimeSelected,
    Function(DateTime)? onMonthChanged,
    Function(String)? onClientFirstNameTextChanged,
    Function()? onSunsetWeatherSelected,
    Function(String)? onOneTimePriceChanged,
    String? oneTimePrice,
    Function(DateTime)? onEndTimeSelected,
    Function(LocationDandy)? onLocationSearchResultSelected,
    double? lat,
    double? lon,
    LocationDandy? oneTimeLocation,
    Function(bool)? onCalendarEnabled,
    Function()? onSkipSelected,
    Function(String)? onClientLastNameTextChanged,
    Function(String)? onClientPhoneTextChanged,
    Function(String)? onClientEmailTextChanged,
    Function(String)? onClientInstagramUrlTextChanged,
    List<Contact>? deviceContacts,
    List<Contact>? filteredDeviceContacts,
    Contact? selectedDeviceContact,
    String? deviceSearchText,
    Function(Contact)? onDeviceContactSelected,
    Function(String)? onContactSearchTextChanged,
    Function(String)? onDeviceContactFirstNameChanged,
  }){
    return NewJobPageState(
      id: id?? this.id,
      documentPath: documentPath ?? this.documentPath,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      clientFirstName: clientFirstName?? this.clientFirstName,
      onClientFirstNameTextChanged: onClientFirstNameTextChanged?? this.onClientFirstNameTextChanged,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      errorState: errorState?? this.errorState,
      selectedClient: selectedClient ?? this.selectedClient,
      clientSearchText: clientSearchText?? this.clientSearchText,
      selectedPriceProfile: selectedPriceProfile?? this.selectedPriceProfile,
      allClients: allClients?? this.allClients,
      filteredClients: filteredClients?? this.filteredClients,
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      selectedLocation: selectedLocation?? this.selectedLocation,
      locations: locations?? this.locations,
      selectedDate: selectedDate?? this.selectedDate,
      selectedStartTime: selectedStartTime?? this.selectedStartTime,
      sunsetDateTime: sunsetDateTime?? this.sunsetDateTime,
      selectedSessionType: selectedSessionType?? this.selectedSessionType,
      currentJobStage: currentJobStage?? this.currentJobStage,
      eventList: eventList?? this.eventList,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onClientSelected:  onClientSelected?? this.onClientSelected,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
      onPriceProfileSelected: onPriceProfileSelected?? this.onPriceProfileSelected,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDateSelected: onDateSelected?? this.onDateSelected,
      onSessionTypeSelected: onSessionTypeSelected?? this.onSessionTypeSelected,
      onStartTimeSelected: onStartTimeSelected?? this.onStartTimeSelected,
      jobs: jobs ?? this.jobs,
      comingFromClientDetails: comingFromClientDetails ?? this.comingFromClientDetails,
      documentId: documentId ?? this.documentId,
      sessionTypes: sessionTypes ?? this.sessionTypes,
      onMonthChanged: onMonthChanged ?? this.onMonthChanged,
      deviceEvents: deviceEvents ?? this.deviceEvents,
      imageFiles: imageFiles ?? this.imageFiles,
      onSunsetWeatherSelected: onSunsetWeatherSelected ?? this.onSunsetWeatherSelected,
      initialTimeSelectorTime: initialTimeSelectorTime ?? this.initialTimeSelectorTime,
      onOneTimePriceChanged: onOneTimePriceChanged ?? this.onOneTimePriceChanged,
      oneTimePrice: oneTimePrice ?? this.oneTimePrice,
      onEndTimeSelected: onEndTimeSelected ?? this.onEndTimeSelected,
      selectedEndTime: selectedEndTime ?? this.selectedEndTime,
      onLocationSearchResultSelected: onLocationSearchResultSelected ?? this.onLocationSearchResultSelected,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      oneTimeLocation: oneTimeLocation ?? this.oneTimeLocation,
      isSelectedClientNew: isSelectedClientNew ?? this.isSelectedClientNew,
      onCalendarEnabled: onCalendarEnabled ?? this.onCalendarEnabled,
      isSelectedPriceProfileNew: isSelectedPriceProfileNew ?? this.isSelectedPriceProfileNew,
      isSelectedSessionTypeNew: isSelectedSessionTypeNew ?? this.isSelectedSessionTypeNew,
      profile: profile ?? this.profile,
      onSkipSelected: onSkipSelected ?? this.onSkipSelected,
      onClientEmailTextChanged: onClientEmailTextChanged ?? this.onClientEmailTextChanged,
      onClientInstagramUrlTextChanged: onClientInstagramUrlTextChanged ?? this.onClientInstagramUrlTextChanged,
      onClientLastNameTextChanged: onClientLastNameTextChanged ?? this.onClientLastNameTextChanged,
      onClientPhoneTextChanged: onClientPhoneTextChanged ?? this.onClientPhoneTextChanged,
      filteredDeviceContacts: filteredDeviceContacts ?? this.filteredDeviceContacts,
      selectedDeviceContact: selectedDeviceContact ?? this.selectedDeviceContact,
      deviceContacts: deviceContacts ?? this.deviceContacts,
      deviceSearchText: deviceSearchText ?? this.deviceSearchText,
      onContactSearchTextChanged: onContactSearchTextChanged ?? this.onContactSearchTextChanged,
      onDeviceContactSelected: onDeviceContactSelected ?? this.onDeviceContactSelected,
      deviceContactEmail: deviceContactEmail ?? this.deviceContactEmail,
      deviceContactFirstName: deviceContactFirstName ?? this.deviceContactFirstName,
      deviceContactLastName: deviceContactLastName ?? this.deviceContactLastName,
      deviceContactPhone: deviceContactPhone ?? this.deviceContactPhone,
      leadSource: leadSource ?? this.leadSource,
      onLeadSourceSelected: onLeadSourceSelected ?? this.onLeadSourceSelected,
      onDeviceContactFirstNameChanged: onDeviceContactFirstNameChanged ?? this.onDeviceContactFirstNameChanged,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      customLeadSourceName: customLeadSourceName ?? this.customLeadSourceName,
      onCustomLeadSourceTextChanged: onCustomLeadSourceTextChanged ?? this.onCustomLeadSourceTextChanged,
    );
  }

  factory NewJobPageState.initial() {
    List<JobStage> selectedStagesInitial = [];
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED));
    return NewJobPageState(
        id: null,
        documentId: '',
        documentPath: '',
        pageViewIndex: 0,
        clientFirstName: '',
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        errorState: NO_ERROR,
        selectedClient: null,
        clientSearchText: "",
        selectedPriceProfile: null,
        selectedLocation: null,
        allClients: const [],
        filteredClients: const [],
        pricingProfiles: const [],
        locations: const [],
        currentJobStage: JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT),
        selectedDate: null,
        deviceEvents: const [],
        selectedStartTime: null,
        selectedEndTime: null,
        sunsetDateTime: null,
        selectedSessionType: null,
        profile: null,
        eventList: const [],
        jobs: const [],
        sessionTypes: const [],
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClearInputSelected: null,
        onPriceProfileSelected: null,
        onLocationSelected: null,
        onDateSelected: null,
        onSessionTypeSelected: null,
        onStartTimeSelected: null,
        comingFromClientDetails: false,
        onMonthChanged: null,
        onClientFirstNameTextChanged: null,
        imageFiles: const [],
        onSunsetWeatherSelected: null,
        initialTimeSelectorTime: DateTime.now(),
        onOneTimePriceChanged: null,
        oneTimePrice: '',
        onEndTimeSelected: null,
        onLocationSearchResultSelected: null,
        lat: 0.0,
        lon: 0.0,
        oneTimeLocation: null,
        isSelectedClientNew: false,
        isSelectedPriceProfileNew: false,
        onCalendarEnabled: null,
        isSelectedSessionTypeNew: false,
        onSkipSelected: null,
        onClientLastNameTextChanged: null,
        onClientPhoneTextChanged: null,
        onClientEmailTextChanged: null,
        onClientInstagramUrlTextChanged: null,
        deviceSearchText: '',
        deviceContacts: const [],
        filteredDeviceContacts: const [],
        selectedDeviceContact: null,
        onContactSearchTextChanged: null,
        onDeviceContactSelected: null,
        deviceContactPhone: '',
        deviceContactLastName: '',
        deviceContactFirstName: '',
        deviceContactEmail: '',
        leadSource: '',
        onLeadSourceSelected: null,
        onDeviceContactFirstNameChanged: null,
        instagramUrl: '',
        customLeadSourceName: '',
        onCustomLeadSourceTextChanged: null,
      );
  }

  factory NewJobPageState.fromStore(Store<AppState> store) {
    return NewJobPageState(
      id: store.state.newJobPageState!.id,
      documentId: store.state.newJobPageState!.documentId,
      documentPath: store.state.newJobPageState!.documentPath,
      pageViewIndex: store.state.newJobPageState!.pageViewIndex,
      saveButtonEnabled: store.state.newJobPageState!.saveButtonEnabled,
      shouldClear: store.state.newJobPageState!.shouldClear,
      isFinishedFetchingClients: store.state.newJobPageState!.isFinishedFetchingClients,
      errorState: store.state.newJobPageState!.errorState,
      selectedClient: store.state.newJobPageState!.selectedClient,
      clientSearchText: store.state.newJobPageState!.clientSearchText,
      selectedPriceProfile: store.state.newJobPageState!.selectedPriceProfile,
      selectedLocation: store.state.newJobPageState!.selectedLocation,
      allClients: store.state.newJobPageState!.allClients,
      deviceEvents: store.state.newJobPageState!.deviceEvents,
      filteredClients: store.state.newJobPageState!.filteredClients,
      pricingProfiles: store.state.newJobPageState!.pricingProfiles,
      locations: store.state.newJobPageState!.locations,
      selectedDate: store.state.newJobPageState!.selectedDate,
      selectedStartTime: store.state.newJobPageState!.selectedStartTime,
      sunsetDateTime: store.state.newJobPageState!.sunsetDateTime,
      selectedSessionType: store.state.newJobPageState!.selectedSessionType,
      currentJobStage: store.state.newJobPageState!.currentJobStage,
      eventList: store.state.newJobPageState!.eventList,
      jobs: store.state.newJobPageState!.jobs,
      comingFromClientDetails: store.state.newJobPageState!.comingFromClientDetails,
      sessionTypes: store.state.newJobPageState!.sessionTypes,
      clientFirstName: store.state.newJobPageState!.clientFirstName,
      imageFiles: store.state.newJobPageState!.imageFiles,
      oneTimePrice: store.state.newJobPageState!.oneTimePrice,
      selectedEndTime: store.state.newJobPageState!.selectedEndTime,
      initialTimeSelectorTime: store.state.newJobPageState!.initialTimeSelectorTime,
      oneTimeLocation: store.state.newJobPageState!.oneTimeLocation,
      lat: store.state.newJobPageState!.lat,
      lon: store.state.newJobPageState!.lon,
      profile: store.state.newJobPageState!.profile,
      isSelectedClientNew: store.state.newJobPageState!.isSelectedClientNew,
      isSelectedSessionTypeNew: store.state.newJobPageState!.isSelectedSessionTypeNew,
      isSelectedPriceProfileNew: store.state.newJobPageState!.isSelectedPriceProfileNew,
      selectedDeviceContact: store.state.newJobPageState!.selectedDeviceContact,
      deviceContacts: store.state.newJobPageState!.deviceContacts,
      deviceSearchText: store.state.newJobPageState!.deviceSearchText,
      filteredDeviceContacts: store.state.newJobPageState!.filteredDeviceContacts,
      deviceContactEmail: store.state.newJobPageState!.deviceContactEmail,
      deviceContactFirstName: store.state.newJobPageState!.deviceContactFirstName,
      deviceContactLastName: store.state.newJobPageState!.deviceContactLastName,
      deviceContactPhone: store.state.newJobPageState!.deviceContactPhone,
      leadSource: store.state.newJobPageState!.leadSource,
      instagramUrl: store.state.newJobPageState!.instagramUrl,
      customLeadSourceName: store.state.newJobPageState!.customLeadSourceName,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
      onPriceProfileSelected: (priceProfile) => store.dispatch(SetSelectedPriceProfile(store.state.newJobPageState, priceProfile)),
      onLocationSelected: (location) => store.dispatch(SetSelectedLocation(store.state.newJobPageState, location)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.newJobPageState, selectedDate)),
      onSessionTypeSelected: (sessionType) => store.dispatch(SetSelectedSessionTypeAction(store.state.newJobPageState, sessionType)),
      onStartTimeSelected: (time) => store.dispatch(SetSelectedStartTimeAction(store.state.newJobPageState, time)),
      onEndTimeSelected: (time) => store.dispatch(SetSelectedEndTimeAction(store.state.newJobPageState, time)),
      onMonthChanged: (month) => store.dispatch(FetchNewJobDeviceEvents(store.state.newJobPageState, month)),
      onClientFirstNameTextChanged: (firstName) => store.dispatch(SetClientFirstNameAction(store.state.newJobPageState, firstName)),
      onSunsetWeatherSelected: () => store.dispatch(sunsetPageActions.LoadInitialLocationAndDateComingFromNewJobAction(store.state.sunsetWeatherPageState, store.state.newJobPageState!.selectedLocation, store.state.newJobPageState!.selectedDate)),
      onOneTimePriceChanged: (inputText) => store.dispatch(SetOneTimePriceTextAction(store.state.newJobPageState, inputText)),
      onLocationSearchResultSelected: (selectedLocation) => store.dispatch(SetSelectedOneTimeLocation(store.state.newJobPageState, selectedLocation)),
      onCalendarEnabled: (enabled) => store.dispatch(FetchNewJobDeviceEvents(store.state.newJobPageState, DateTime.now())),
      onSkipSelected: () => store.dispatch(UpdateProfileToOnBoardingCompleteAction(store.state.newJobPageState)),
      onClientEmailTextChanged: (email) => store.dispatch(UpdateClientEmailAction(store.state.newJobPageState, email)),
      onClientLastNameTextChanged: (lastName) => store.dispatch(UpdateClientLastNameAction(store.state.newJobPageState, lastName)),
      onClientPhoneTextChanged: (phone) => store.dispatch(UpdateClientPhoneAction(store.state.newJobPageState, phone)),
      onClientInstagramUrlTextChanged: (url) => store.dispatch(UpdateClientInstagramUrlAction(store.state.newJobPageState, url)),
      onDeviceContactSelected: (deviceContact) => store.dispatch(SetSelectedNewJobDeviceContactAction(store.state.newJobPageState, deviceContact)),
      onContactSearchTextChanged: (searchText) => store.dispatch(FilterDeviceContactsNewJobAction(store.state.newJobPageState, searchText)),
      onLeadSourceSelected: (sourceName) => store.dispatch(SetLeadSourceAction(store.state.newJobPageState, sourceName)),
      onDeviceContactFirstNameChanged: (firstName) => store.dispatch(SetDeviceClientFirstNameAction(store.state.newJobPageState, firstName)),
      onCustomLeadSourceTextChanged: (customName) => store.dispatch(SetCustomLeadSourceAction(store.state.newJobPageState, customName)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      onContactSearchTextChanged.hashCode ^
      onDeviceContactSelected.hashCode ^
      customLeadSourceName.hashCode ^
      onCustomLeadSourceTextChanged.hashCode ^
      pageViewIndex.hashCode ^
      documentPath.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      onDeviceContactFirstNameChanged.hashCode ^
      isSelectedClientNew.hashCode ^
      isFinishedFetchingClients.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
      deviceEvents.hashCode ^
      profile.hashCode ^
      isSelectedSessionTypeNew.hashCode ^
      selectedPriceProfile.hashCode ^
      selectedLocation.hashCode ^
      filteredClients.hashCode ^
      pricingProfiles.hashCode ^
      locations.hashCode ^
      isSelectedPriceProfileNew.hashCode ^
      selectedDate.hashCode ^
      selectedStartTime.hashCode ^
      sunsetDateTime.hashCode ^
      selectedSessionType.hashCode ^
      currentJobStage.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      instagramUrl.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClearInputSelected.hashCode ^
      onLocationSelected.hashCode ^
      onDateSelected.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      deviceContactEmail.hashCode ^
      deviceContactPhone.hashCode ^
      deviceContactFirstName.hashCode ^
      deviceContactLastName.hashCode ^
      onStartTimeSelected.hashCode ^
      sessionTypes.hashCode ^
      clientFirstName.hashCode ^
      onClientFirstNameTextChanged.hashCode ^
      onSunsetWeatherSelected.hashCode ^
      initialTimeSelectorTime.hashCode ^
      onOneTimePriceChanged.hashCode ^
      oneTimePrice.hashCode ^
      onEndTimeSelected.hashCode ^
      selectedEndTime.hashCode ^
      onLocationSearchResultSelected.hashCode ^
      lat.hashCode ^
      lon.hashCode ^
      oneTimeLocation.hashCode ^
      onSkipSelected.hashCode ^
      onClientPhoneTextChanged.hashCode ^
      onClientEmailTextChanged.hashCode ^
      onClientLastNameTextChanged.hashCode ^
      onClientInstagramUrlTextChanged.hashCode ^
      deviceSearchText.hashCode ^
      selectedDeviceContact.hashCode ^
      filteredDeviceContacts.hashCode ^
      deviceContacts.hashCode ^
      leadSource.hashCode ^
      onLeadSourceSelected.hashCode ^
      imageFiles.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobPageState &&
          id == other.id &&
          documentId == other.documentId &&
          documentPath == other.documentPath &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          errorState == other.errorState &&
          clientFirstName == other.clientFirstName &&
          onClientFirstNameTextChanged == other.onClientFirstNameTextChanged &&
          selectedClient == other.selectedClient &&
          clientSearchText == other.clientSearchText &&
          allClients == other.allClients &&
          profile == other.profile &&
          instagramUrl == other.instagramUrl &&
          onDeviceContactFirstNameChanged == other.onDeviceContactFirstNameChanged &&
          onContactSearchTextChanged == other.onContactSearchTextChanged &&
          onDeviceContactSelected == other.onDeviceContactSelected &&
          filteredClients == other.filteredClients &&
          selectedPriceProfile == other.selectedPriceProfile &&
          selectedLocation == other.selectedLocation &&
          pricingProfiles == other.pricingProfiles &&
          isSelectedSessionTypeNew == other.isSelectedSessionTypeNew &&
          locations == other.locations &&
          customLeadSourceName == other.customLeadSourceName &&
          onCustomLeadSourceTextChanged == other.onCustomLeadSourceTextChanged &&
          selectedDate == other.selectedDate &&
          isSelectedPriceProfileNew == other.isSelectedPriceProfileNew &&
          selectedStartTime == other.selectedStartTime &&
          sunsetDateTime == other.sunsetDateTime &&
          deviceEvents == other.deviceEvents &&
          deviceContactFirstName == other.deviceContactFirstName &&
          deviceContactLastName == other.deviceContactLastName &&
          deviceContactEmail == other.deviceContactEmail &&
          deviceContactPhone == other.deviceContactPhone &&
          selectedSessionType == other.selectedSessionType &&
          onSkipSelected == other.onSkipSelected &&
          currentJobStage == other.currentJobStage &&
          onSavePressed == other.onSavePressed &&
          isSelectedClientNew == other.isSelectedClientNew &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onClientSelected == other.onClientSelected &&
          onClearInputSelected == other.onClearInputSelected &&
          onDateSelected == other.onDateSelected &&
          eventList == other.eventList &&
          jobs == other.jobs &&
          onStartTimeSelected == other.onStartTimeSelected &&
          sessionTypes == other.sessionTypes &&
          onSunsetWeatherSelected == other.onSunsetWeatherSelected &&
          initialTimeSelectorTime == other.initialTimeSelectorTime &&
          onOneTimePriceChanged == other.onOneTimePriceChanged &&
          oneTimePrice == other.oneTimePrice &&
          onEndTimeSelected == other.onEndTimeSelected &&
          selectedEndTime == other.selectedEndTime &&
          onLocationSearchResultSelected == other.onLocationSearchResultSelected &&
          lat == other.lat &&
          lon == other.lon &&
          oneTimeLocation == other.oneTimeLocation &&
          onClientLastNameTextChanged == other.onClientLastNameTextChanged &&
          onClientPhoneTextChanged == other.onClientPhoneTextChanged &&
          onClientEmailTextChanged == other.onClientEmailTextChanged &&
          onClientInstagramUrlTextChanged == other.onClientInstagramUrlTextChanged &&
          deviceContacts == other.deviceContacts &&
          selectedDeviceContact == other.selectedDeviceContact &&
          deviceSearchText == other.deviceSearchText &&
          filteredDeviceContacts == other.filteredDeviceContacts &&
          leadSource == other.leadSource &&
          onLeadSourceSelected == other.onLeadSourceSelected &&
          imageFiles == other.imageFiles;
}
