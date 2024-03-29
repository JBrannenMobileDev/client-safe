import 'dart:io';

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
  final bool? isSelectedJobTypeNew;
  final String? errorState;
  final Client? selectedClient;
  final String? clientFirstName;
  final String? clientSearchText;
  final String? documentPath;
  final String? oneTimePrice;
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
  final JobType? selectedJobType;
  final List<Client>? allClients;
  final List<Client>? filteredClients;
  final List<PriceProfile>? pricingProfiles;
  final List<LocationDandy>? locations;
  final List<File?>? imageFiles;
  final List<EventDandyLight>? eventList;
  final List<Event>? deviceEvents;
  final List<Job>? jobs;
  final List<JobType>? jobTypes;
  final Function()? onSavePressed;
  final Function()? onCancelPressed;
  final Function()? onNextPressed;
  final Function()? onBackPressed;
  final Function(Client)? onClientSelected;
  final Function(String)? onClientFirstNameTextChanged;
  final Function()? onClearInputSelected;
  final Function(PriceProfile)? onPriceProfileSelected;
  final Function(LocationDandy)? onLocationSelected;
  final Function(DateTime)? onDateSelected;
  final Function(JobType)? onJobTypeSelected;
  final Function(DateTime)? onStartTimeSelected;
  final Function(DateTime)? onEndTimeSelected;
  final Function(Job)? onJobClicked;
  final Function(DateTime)? onMonthChanged;
  final Function()? onSunsetWeatherSelected;
  final Function(String)? onOneTimePriceChanged;
  final Function(LocationDandy)? onLocationSearchResultSelected;
  final double? lat;
  final double? lon;
  final Function(bool)? onCalendarEnabled;
  final Function()? onSkipSelected;

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
    @required this.selectedJobType,
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
    @required this.onJobTypeSelected,
    @required this.currentJobStage,
    @required this.onStartTimeSelected,
    @required this.onJobClicked,
    @required this.jobTypes,
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
    @required this.isSelectedJobTypeNew,
    @required this.profile,
    @required this.onSkipSelected,
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
    bool? isSelectedJobTypeNew,
    String? errorState,
    Client? selectedClient,
    String? clientFirstName,
    String? clientSearchText,
    PriceProfile? selectedPriceProfile,
    LocationDandy? selectedLocation,
    List<Client>? allClients,
    List<Client>? filteredClients,
    List<PriceProfile>? pricingProfiles,
    List<LocationDandy>? locations,
    List<File?>? imageFiles,
    Profile? profile,
    DateTime? selectedDate,
    DateTime? selectedStartTime,
    DateTime? selectedEndTime,
    DateTime? sunsetDateTime,
    DateTime? initialTimeSelectorTime,
    JobType? jobType,
    JobType? selectedJobType,
    List<EventDandyLight>? eventList,
    List<Event>? deviceEvents,
    List<Job>? jobs,
    List<JobType>? jobTypes,
    Function()? onSavePressed,
    Function()? onCancelPressed,
    Function()? onNextPressed,
    Function()? onBackPressed,
    Function(Client)? onClientSelected,
    Function()? onClearInputSelected,
    Function(PriceProfile)? onPriceProfileSelected,
    Function(LocationDandy)? onLocationSelected,
    Function(DateTime)? onDateSelected,
    Function(JobType)? onJobTypeSelected,
    Function(DateTime)? onStartTimeSelected,
    Function(Job)? onJobClicked,
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
      selectedJobType: selectedJobType?? this.selectedJobType,
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
      onJobTypeSelected: onJobTypeSelected?? this.onJobTypeSelected,
      onStartTimeSelected: onStartTimeSelected?? this.onStartTimeSelected,
      jobs: jobs ?? this.jobs,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      comingFromClientDetails: comingFromClientDetails ?? this.comingFromClientDetails,
      documentId: documentId ?? this.documentId,
      jobTypes: jobTypes ?? this.jobTypes,
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
      isSelectedJobTypeNew: isSelectedJobTypeNew ?? this.isSelectedJobTypeNew,
      profile: profile ?? this.profile,
      onSkipSelected: onSkipSelected ?? this.onSkipSelected,
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
        allClients: [],
        filteredClients: [],
        pricingProfiles: [],
        locations: [],
        currentJobStage: JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT),
        selectedDate: null,
        deviceEvents: [],
        selectedStartTime: null,
        selectedEndTime: null,
        sunsetDateTime: null,
        selectedJobType: null,
        profile: null,
        eventList: [],
        jobs: [],
        jobTypes: [],
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClearInputSelected: null,
        onPriceProfileSelected: null,
        onLocationSelected: null,
        onDateSelected: null,
        onJobTypeSelected: null,
        onStartTimeSelected: null,
        onJobClicked: null,
        comingFromClientDetails: false,
        onMonthChanged: null,
        onClientFirstNameTextChanged: null,
        imageFiles: [],
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
        isSelectedJobTypeNew: false,
        onSkipSelected: null,
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
      selectedJobType: store.state.newJobPageState!.selectedJobType,
      currentJobStage: store.state.newJobPageState!.currentJobStage,
      eventList: store.state.newJobPageState!.eventList,
      jobs: store.state.newJobPageState!.jobs,
      comingFromClientDetails: store.state.newJobPageState!.comingFromClientDetails,
      jobTypes: store.state.newJobPageState!.jobTypes,
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
      isSelectedJobTypeNew: store.state.newJobPageState!.isSelectedJobTypeNew,
      isSelectedPriceProfileNew: store.state.newJobPageState!.isSelectedPriceProfileNew,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
      onPriceProfileSelected: (priceProfile) => store.dispatch(SetSelectedPriceProfile(store.state.newJobPageState, priceProfile)),
      onLocationSelected: (location) => store.dispatch(SetSelectedLocation(store.state.newJobPageState, location)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.newJobPageState, selectedDate)),
      onJobTypeSelected: (jobType) => store.dispatch(SetSelectedJobTypeAction(store.state.newJobPageState, jobType)),
      onStartTimeSelected: (time) => store.dispatch(SetSelectedStartTimeAction(store.state.newJobPageState, time)),
      onEndTimeSelected: (time) => store.dispatch(SetSelectedEndTimeAction(store.state.newJobPageState, time)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job.documentId)),
      onMonthChanged: (month) => store.dispatch(FetchNewJobDeviceEvents(store.state.newJobPageState, month)),
      onClientFirstNameTextChanged: (firstName) => store.dispatch(SetClientFirstNameAction(store.state.newJobPageState, firstName)),
      onSunsetWeatherSelected: () => store.dispatch(sunsetPageActions.LoadInitialLocationAndDateComingFromNewJobAction(store.state.sunsetWeatherPageState, store.state.newJobPageState!.selectedLocation, store.state.newJobPageState!.selectedDate)),
      onOneTimePriceChanged: (inputText) => store.dispatch(SetOneTimePriceTextAction(store.state.newJobPageState, inputText)),
      onLocationSearchResultSelected: (selectedLocation) => store.dispatch(SetSelectedOneTimeLocation(store.state.newJobPageState, selectedLocation)),
      onCalendarEnabled: (enabled) => store.dispatch(FetchNewJobDeviceEvents(store.state.newJobPageState, DateTime.now())),
      onSkipSelected: () => store.dispatch(UpdateProfileToOnBoardingCompleteAction(store.state.newJobPageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      pageViewIndex.hashCode ^
      documentPath.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isSelectedClientNew.hashCode ^
      isFinishedFetchingClients.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
      deviceEvents.hashCode ^
      profile.hashCode ^
      isSelectedJobTypeNew.hashCode ^
      selectedPriceProfile.hashCode ^
      selectedLocation.hashCode ^
      filteredClients.hashCode ^
      pricingProfiles.hashCode ^
      locations.hashCode ^
      isSelectedPriceProfileNew.hashCode ^
      selectedDate.hashCode ^
      selectedStartTime.hashCode ^
      sunsetDateTime.hashCode ^
      selectedJobType.hashCode ^
      currentJobStage.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClearInputSelected.hashCode ^
      onLocationSelected.hashCode ^
      onDateSelected.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      onStartTimeSelected.hashCode ^
      onJobClicked.hashCode ^
      jobTypes.hashCode ^
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
          filteredClients == other.filteredClients &&
          selectedPriceProfile == other.selectedPriceProfile &&
          selectedLocation == other.selectedLocation &&
          pricingProfiles == other.pricingProfiles &&
          isSelectedJobTypeNew == other.isSelectedJobTypeNew &&
          locations == other.locations &&
          selectedDate == other.selectedDate &&
          isSelectedPriceProfileNew == other.isSelectedPriceProfileNew &&
          selectedStartTime == other.selectedStartTime &&
          sunsetDateTime == other.sunsetDateTime &&
          deviceEvents == other.deviceEvents &&
          selectedJobType == other.selectedJobType &&
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
          onJobClicked == other.onJobClicked &&
          jobTypes == other.jobTypes &&
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
          imageFiles == other.imageFiles;
}
