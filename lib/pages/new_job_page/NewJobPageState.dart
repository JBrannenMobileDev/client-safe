import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/ReminderDandyLight.dart';
import '../../utils/StringUtils.dart';

@immutable
class NewJobPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";

  final int id;
  final String documentId;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool comingFromClientDetails;
  final bool isFinishedFetchingClients;
  final String errorState;
  final Client selectedClient;
  final String clientFirstName;
  final String clientLastName;
  final String clientSearchText;
  final String jobTitle;
  final String documentPath;
  final PriceProfile selectedPriceProfile;
  final Location selectedLocation;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final DateTime sunsetDateTime;
  final List<JobStage> selectedJobStages;
  final List<ReminderDandyLight> allReminders;
  final List<ReminderDandyLight> selectedReminders;
  final JobStage currentJobStage;
  final String jobType;
  final String selectedJobType;
  final int depositAmount;
  final List<Job> upcomingJobs;
  final List<Client> allClients;
  final List<Client> filteredClients;
  final List<PriceProfile> pricingProfiles;
  final List<Location> locations;
  final List<File> imageFiles;
  final List<EventDandyLight> eventList;
  final List<Event> deviceEvents;
  final List<Job> jobs;
  final List<String> jobTypes;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Client) onClientSelected;
  final Function(String) onClientFirstNameTextChanged;
  final Function(String) onClientLastNameTextChanged;
  final Function() onClearInputSelected;
  final Function(String) onJobTitleTextChanged;
  final Function(PriceProfile) onPriceProfileSelected;
  final Function(Location) onLocationSelected;
  final Function(DateTime) onDateSelected;
  final Function(JobStage) onJobStageSelected;
  final Function(ReminderDandyLight) onReminderSelected;
  final Function(String) onJobTypeSelected;
  final Function(DateTime) onTimeSelected;
  final Function(Job) onJobClicked;
  final Function(int) onAddToDeposit;
  final Function() clearDepositAmount;
  final Function(DateTime) onMonthChanged;

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
    @required this.jobTitle,
    @required this.selectedPriceProfile,
    @required this.selectedLocation,
    @required this.selectedDate,
    @required this.selectedTime,
    @required this.sunsetDateTime,
    @required this.selectedJobStages,
    @required this.jobType,
    @required this.selectedJobType,
    @required this.upcomingJobs,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.selectedClient,
    @required this.onClientSelected,
    @required this.onClearInputSelected,
    @required this.allClients,
    @required this.filteredClients,
    @required this.onJobTitleTextChanged,
    @required this.pricingProfiles,
    @required this.onPriceProfileSelected,
    @required this.locations,
    @required this.eventList,
    @required this.jobs,
    @required this.onLocationSelected,
    @required this.onDateSelected,
    @required this.onJobStageSelected,
    @required this.onJobTypeSelected,
    @required this.currentJobStage,
    @required this.onTimeSelected,
    @required this.onJobClicked,
    @required this.depositAmount,
    @required this.onAddToDeposit,
    @required this.clearDepositAmount,
    @required this.allReminders,
    @required this.selectedReminders,
    @required this.onReminderSelected,
    @required this.jobTypes,
    @required this.onMonthChanged,
    @required this.deviceEvents,
    @required this.clientFirstName,
    @required this.clientLastName,
    @required this.onClientFirstNameTextChanged,
    @required this.onClientLastNameTextChanged,
    @required this.imageFiles,
  });

  NewJobPageState copyWith({
    int id,
    String documentId,
    String documentPath,
    int pageViewIndex,
    bool comingFromClientDetails,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    String errorState,
    Client selectedClient,
    String clientFirstName,
    String clientLastName,
    String clientSearchText,
    String jobTitle,
    PriceProfile selectedPriceProfile,
    Location selectedLocation,
    List<Client> allClients,
    List<Client> filteredClients,
    List<PriceProfile> pricingProfiles,
    List<Location> locations,
    List<File> imageFiles,
    DateTime selectedDate,
    DateTime selectedTime,
    DateTime sunsetDateTime,
    List<JobStage> selectedJobStages,
    List<ReminderDandyLight> allReminders,
    List<ReminderDandyLight> selectedReminders,
    String jobType,
    String selectedJobType,
    int depositAmount,
    JobStage currentJobStage,
    List<Job> upcomingJobs,
    List<EventDandyLight> eventList,
    List<Event> deviceEvents,
    List<Job> jobs,
    List<String> jobTypes,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Client) onClientSelected,
    Function() onClearInputSelected,
    Function(String) onJobTitleTextChanged,
    Function(PriceProfile) onPriceProfileSelected,
    Function(Location) onLocationSelected,
    Function(DateTime) onDateSelected,
    Function(String) onJobStageSelected,
    Function(String) onJobTypeSelected,
    Function(DateTime) onTimeSelected,
    Function(Job) onJobClicked,
    Function(int) onAddToDeposit,
    Function() clearDepositAmount,
    Function(ReminderDandyLight) onReminderSelected,
    Function(DateTime) onMonthChanged,
    Function(String) onClientFirstNameTextChanged,
    Function(String) onClientLastNameTextChanged,
  }){
    return NewJobPageState(
      id: id?? this.id,
      documentPath: documentPath ?? this.documentPath,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      clientFirstName: clientFirstName?? this.clientFirstName,
      clientLastName: clientLastName?? this.clientLastName,
      onClientFirstNameTextChanged: onClientFirstNameTextChanged?? this.onClientFirstNameTextChanged,
      onClientLastNameTextChanged: onClientLastNameTextChanged?? this.onClientLastNameTextChanged,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      errorState: errorState?? this.errorState,
      selectedClient: selectedClient,
      clientSearchText: clientSearchText?? this.clientSearchText,
      jobTitle: jobTitle?? this.jobTitle,
      selectedPriceProfile: selectedPriceProfile?? this.selectedPriceProfile,
      allClients: allClients?? this.allClients,
      filteredClients: filteredClients?? this.filteredClients,
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      selectedLocation: selectedLocation?? this.selectedLocation,
      locations: locations?? this.locations,
      selectedDate: selectedDate?? this.selectedDate,
      selectedTime: selectedTime?? this.selectedTime,
      sunsetDateTime: sunsetDateTime?? this.sunsetDateTime,
      selectedJobStages: selectedJobStages?? this.selectedJobStages,
      jobType: jobType?? this.jobType,
      selectedJobType: selectedJobType?? this.selectedJobType,
      currentJobStage: currentJobStage?? this.currentJobStage,
      upcomingJobs: upcomingJobs?? this.upcomingJobs,
      eventList: eventList?? this.eventList,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onClientSelected:  onClientSelected?? this.onClientSelected,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
      onJobTitleTextChanged: onJobTitleTextChanged?? this.onJobTitleTextChanged,
      onPriceProfileSelected: onPriceProfileSelected?? this.onPriceProfileSelected,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDateSelected: onDateSelected?? this.onDateSelected,
      onJobStageSelected: onJobStageSelected?? this.onJobStageSelected,
      onJobTypeSelected: onJobTypeSelected?? this.onJobTypeSelected,
      onTimeSelected: onTimeSelected?? this.onTimeSelected,
      jobs: jobs ?? this.jobs,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      depositAmount: depositAmount ?? this.depositAmount,
      onAddToDeposit: onAddToDeposit ?? this.onAddToDeposit,
      clearDepositAmount: clearDepositAmount ?? this.clearDepositAmount,
      comingFromClientDetails: comingFromClientDetails ?? this.comingFromClientDetails,
      documentId: documentId ?? this.documentId,
      allReminders: allReminders ?? this.allReminders,
      selectedReminders: selectedReminders ?? this.selectedReminders,
      onReminderSelected: onReminderSelected ?? this.onReminderSelected,
      jobTypes: jobTypes ?? this.jobTypes,
      onMonthChanged: onMonthChanged ?? this.onMonthChanged,
      deviceEvents: deviceEvents ?? this.deviceEvents,
      imageFiles: imageFiles ?? this.imageFiles,
    );
  }

  factory NewJobPageState.initial() {
    List<JobStage> selectedStagesInitial = [];
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1));
    return NewJobPageState(
        id: null,
        documentId: '',
        documentPath: '',
        pageViewIndex: 0,
        clientFirstName: '',
        clientLastName: '',
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        errorState: NO_ERROR,
        selectedClient: null,
        clientSearchText: "",
        jobTitle: "",
        selectedPriceProfile: null,
        selectedLocation: null,
        allClients: [],
        filteredClients: [],
        pricingProfiles: [],
        locations: [],
        currentJobStage: JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT, value: 2),
        selectedDate: DateTime.now(),
        deviceEvents: [],
        selectedTime: null,
        sunsetDateTime: null,
        selectedJobStages: selectedStagesInitial,
        jobType: Job.JOB_TYPE_OTHER,
        selectedJobType: null,
        upcomingJobs: [],
        eventList: [],
        jobs: [],
        jobTypes: StringUtils.getJobTypesList(),
        depositAmount: 0,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClearInputSelected: null,
        onJobTitleTextChanged: null,
        onPriceProfileSelected: null,
        onLocationSelected: null,
        onDateSelected: null,
        onJobStageSelected: null,
        onJobTypeSelected: null,
        onTimeSelected: null,
        onJobClicked: null,
        onAddToDeposit: null,
        clearDepositAmount: null,
        comingFromClientDetails: false,
        allReminders: [],
        selectedReminders: [],
        onReminderSelected: null,
        onMonthChanged: null,
        onClientFirstNameTextChanged: null,
        onClientLastNameTextChanged: null,
        imageFiles: [],
      );
  }

  factory NewJobPageState.fromStore(Store<AppState> store) {
    return NewJobPageState(
      id: store.state.newJobPageState.id,
      documentId: store.state.newJobPageState.documentId,
      documentPath: store.state.newJobPageState.documentPath,
      pageViewIndex: store.state.newJobPageState.pageViewIndex,
      saveButtonEnabled: store.state.newJobPageState.saveButtonEnabled,
      shouldClear: store.state.newJobPageState.shouldClear,
      isFinishedFetchingClients: store.state.newJobPageState.isFinishedFetchingClients,
      errorState: store.state.newJobPageState.errorState,
      selectedClient: store.state.newJobPageState.selectedClient,
      clientSearchText: store.state.newJobPageState.clientSearchText,
      jobTitle: store.state.newJobPageState.jobTitle,
      selectedPriceProfile: store.state.newJobPageState.selectedPriceProfile,
      selectedLocation: store.state.newJobPageState.selectedLocation,
      allClients: store.state.newJobPageState.allClients,
      deviceEvents: store.state.newJobPageState.deviceEvents,
      filteredClients: store.state.newJobPageState.filteredClients,
      pricingProfiles: store.state.newJobPageState.pricingProfiles,
      locations: store.state.newJobPageState.locations,
      selectedDate: store.state.newJobPageState.selectedDate,
      selectedTime: store.state.newJobPageState.selectedTime,
      sunsetDateTime: store.state.newJobPageState.sunsetDateTime,
      selectedJobStages: store.state.newJobPageState.selectedJobStages,
      jobType: store.state.newJobPageState.jobType,
      selectedJobType: store.state.newJobPageState.selectedJobType,
      currentJobStage: store.state.newJobPageState.currentJobStage,
      upcomingJobs: store.state.newJobPageState.upcomingJobs,
      eventList: store.state.newJobPageState.eventList,
      jobs: store.state.newJobPageState.jobs,
      depositAmount: store.state.newJobPageState.depositAmount,
      allReminders: store.state.newJobPageState.allReminders,
      selectedReminders: store.state.newJobPageState.selectedReminders,
      comingFromClientDetails: store.state.newJobPageState.comingFromClientDetails,
      jobTypes: store.state.newJobPageState.jobTypes,
      clientFirstName: store.state.newJobPageState.clientFirstName,
      clientLastName: store.state.newJobPageState.clientLastName,
      imageFiles: store.state.newJobPageState.imageFiles,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
      onJobTitleTextChanged: (jobTitle) => store.dispatch(SetJobTitleAction(store.state.newJobPageState, jobTitle)),
      onPriceProfileSelected: (priceProfile) => store.dispatch(SetSelectedPriceProfile(store.state.newJobPageState, priceProfile)),
      onLocationSelected: (location) => store.dispatch(SetSelectedLocation(store.state.newJobPageState, location)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.newJobPageState, selectedDate)),
      onJobStageSelected: (jobStage) => store.dispatch(SetSelectedJobStageAction(store.state.newJobPageState, jobStage)),
      onJobTypeSelected: (jobType) => store.dispatch(SetSelectedJobTypeAction(store.state.newJobPageState, jobType)),
      onTimeSelected: (time) => store.dispatch(SetSelectedTimeAction(store.state.newJobPageState, time)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
      onAddToDeposit: (amountToAdd) => store.dispatch(AddToDepositAmountAction(store.state.newJobPageState, amountToAdd)),
      clearDepositAmount: () => store.dispatch(ClearDepositAction(store.state.newJobPageState)),
      onReminderSelected: (reminder) => store.dispatch(SetSelectedJobReminderAction(store.state.newJobPageState, reminder)),
      onMonthChanged: (month) => store.dispatch(FetchNewJobDeviceEvents(store.state.newJobPageState, month)),
      onClientLastNameTextChanged: (lastName) => store.dispatch(SetClientLastNameAction(store.state.newJobPageState, lastName)),
      onClientFirstNameTextChanged: (firstName) => store.dispatch(SetClientFirstNameAction(store.state.newJobPageState, firstName)),
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
      isFinishedFetchingClients.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
      deviceEvents.hashCode ^
      selectedPriceProfile.hashCode ^
      selectedLocation.hashCode ^
      filteredClients.hashCode ^
      pricingProfiles.hashCode ^
      locations.hashCode ^
      selectedDate.hashCode ^
      selectedTime.hashCode ^
      sunsetDateTime.hashCode ^
      selectedJobStages.hashCode ^
      jobType.hashCode ^
      selectedJobType.hashCode ^
      currentJobStage.hashCode ^
      upcomingJobs.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClearInputSelected.hashCode ^
      onLocationSelected.hashCode ^
      onDateSelected.hashCode ^
      onJobStageSelected.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      onTimeSelected.hashCode ^
      onJobClicked.hashCode ^
      depositAmount.hashCode ^
      onAddToDeposit.hashCode ^
      jobTypes.hashCode ^
      clientFirstName.hashCode ^
      clientLastName.hashCode ^
      onClientLastNameTextChanged.hashCode ^
      onClientFirstNameTextChanged.hashCode ^
      imageFiles.hashCode ^
      clearDepositAmount.hashCode;

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
          clientLastName == other.clientLastName &&
          onClientFirstNameTextChanged == other.onClientFirstNameTextChanged &&
          onClientLastNameTextChanged == other.onClientLastNameTextChanged &&
          selectedClient == other.selectedClient &&
          clientSearchText == other.clientSearchText &&
          allClients == other.allClients &&
          filteredClients == other.filteredClients &&
          selectedPriceProfile == other.selectedPriceProfile &&
          selectedLocation == other.selectedLocation &&
          pricingProfiles == other.pricingProfiles &&
          locations == other.locations &&
          selectedDate == other.selectedDate &&
          selectedTime == other.selectedTime &&
          sunsetDateTime == other.sunsetDateTime &&
          selectedJobStages == other.selectedJobStages &&
          jobType == other.jobType &&
          deviceEvents == other.deviceEvents &&
          selectedJobType == other.selectedJobType &&
          currentJobStage == other.currentJobStage &&
          upcomingJobs == other.upcomingJobs &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onClientSelected == other.onClientSelected &&
          onClearInputSelected == other.onClearInputSelected &&
          onDateSelected == other.onDateSelected &&
          onJobStageSelected == other.onJobStageSelected &&
          eventList == other.eventList &&
          jobs == other.jobs &&
          onTimeSelected == other.onTimeSelected &&
          onJobClicked == other.onJobClicked &&
          depositAmount == other.depositAmount &&
          onAddToDeposit == other.onAddToDeposit &&
          jobTypes == other.jobTypes &&
          imageFiles == other.imageFiles &&
          clearDepositAmount == other.clearDepositAmount;
}
