import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewJobPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool isFinishedFetchingClients;
  final String errorState;
  final Client selectedClient;
  final String clientSearchText;
  final String jobTitle;
  final PriceProfile selectedPriceProfile;
  final Location selectedLocation;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final DateTime sunsetDateTime;
  final List<JobStage> selectedJobStages;
  final JobStage currentJobStage;
  final String jobType;
  final String jobTypeIcon;
  final List<Job> upcomingJobs;
  final List<Client> allClients;
  final List<Client> filteredClients;
  final List<PriceProfile> pricingProfiles;
  final List<Location> locations;
  final Map<DateTime, List<Event>> eventMap;
  final List<Job> jobs;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Client) onClientSelected;
  final Function(String) onClientSearchTextChanged;
  final Function() onClearInputSelected;
  final Function(String) onJobTitleTextChanged;
  final Function(PriceProfile) onPriceProfileSelected;
  final Function(Location) onLocationSelected;
  final Function(DateTime) onDateSelected;
  final Function(JobStage) onJobStageSelected;
  final Function(String) onJobTypeSelected;
  final Function(DateTime) onTimeSelected;
  final Function(Job) onJobClicked;

  NewJobPageState({
    @required this.id,
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
    @required this.jobTypeIcon,
    @required this.upcomingJobs,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.selectedClient,
    @required this.onClientSelected,
    @required this.onClientSearchTextChanged,
    @required this.onClearInputSelected,
    @required this.allClients,
    @required this.filteredClients,
    @required this.onJobTitleTextChanged,
    @required this.pricingProfiles,
    @required this.onPriceProfileSelected,
    @required this.locations,
    @required this.eventMap,
    @required this.jobs,
    @required this.onLocationSelected,
    @required this.onDateSelected,
    @required this.onJobStageSelected,
    @required this.onJobTypeSelected,
    @required this.currentJobStage,
    @required this.onTimeSelected,
    @required this.onJobClicked,
  });

  NewJobPageState copyWith({
    int id,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    String errorState,
    Client selectedClient,
    String clientSearchText,
    String jobTitle,
    PriceProfile selectedPriceProfile,
    Location selectedLocation,
    List<Client> allClients,
    List<Client> filteredClients,
    List<PriceProfile> pricingProfiles,
    List<Location> locations,
    DateTime selectedDate,
    DateTime selectedTime,
    DateTime sunsetDateTime,
    List<JobStage> selectedJobStages,
    String jobType,
    String jobTypeIcon,
    JobStage currentJobStage,
    List<Job> upcomingJobs,
    Map<DateTime, List<Event>> eventMap,
    List<Job> jobs,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Client) onClientSelected,
    Function(String) onClientSearchTextChanged,
    Function() onClearInputSelected,
    Function(String) onJobTitleTextChanged,
    Function(PriceProfile) onPriceProfileSelected,
    Function(Location) onLocationSelected,
    Function(DateTime) onDateSelected,
    Function(String) onJobStageSelected,
    Function(String) onJobTypeSelected,
    Function(DateTime) onTimeSelected,
    Function(Job) onJobClicked,
  }){
    return NewJobPageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      errorState: errorState?? this.errorState,
      selectedClient: selectedClient?? this.selectedClient,
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
      jobTypeIcon: jobTypeIcon?? this.jobTypeIcon,
      currentJobStage: currentJobStage?? this.currentJobStage,
      upcomingJobs: upcomingJobs?? this.upcomingJobs,
      eventMap: eventMap?? this.eventMap,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onClientSelected:  onClientSelected?? this.onClientSelected,
      onClientSearchTextChanged: onClientSearchTextChanged?? this.onClientSearchTextChanged,
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
    );
  }

  factory NewJobPageState.initial() {
    List<JobStage> selectedStagesInitial = List();
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1));
    return NewJobPageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        errorState: NO_ERROR,
        selectedClient: null,
        clientSearchText: "",
        jobTitle: "",
        selectedPriceProfile: null,
        selectedLocation: null,
        allClients: List(),
        filteredClients: List(),
        pricingProfiles: List(),
        locations: List(),
        currentJobStage: JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT, value: 2),
        selectedDate: null,
        selectedTime: null,
        sunsetDateTime: null,
        selectedJobStages: selectedStagesInitial,
        jobType: Job.JOB_TYPE_OTHER,
        jobTypeIcon: 'assets/images/job_types/other.png',
        upcomingJobs: List(),
        eventMap: Map(),
        jobs: List(),
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClientSearchTextChanged: null,
        onClearInputSelected: null,
        onJobTitleTextChanged: null,
        onPriceProfileSelected: null,
        onLocationSelected: null,
        onDateSelected: null,
        onJobStageSelected: null,
        onJobTypeSelected: null,
        onTimeSelected: null,
        onJobClicked: null,
      );
  }

  factory NewJobPageState.fromStore(Store<AppState> store) {
    return NewJobPageState(
      id: store.state.newJobPageState.id,
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
      filteredClients: store.state.newJobPageState.filteredClients,
      pricingProfiles: store.state.newJobPageState.pricingProfiles,
      locations: store.state.newJobPageState.locations,
      selectedDate: store.state.newJobPageState.selectedDate,
      selectedTime: store.state.newJobPageState.selectedTime,
      sunsetDateTime: store.state.newJobPageState.sunsetDateTime,
      selectedJobStages: store.state.newJobPageState.selectedJobStages,
      jobType: store.state.newJobPageState.jobType,
      jobTypeIcon: store.state.newJobPageState.jobTypeIcon,
      currentJobStage: store.state.newJobPageState.currentJobStage,
      upcomingJobs: store.state.newJobPageState.upcomingJobs,
      eventMap: store.state.newJobPageState.eventMap,
      jobs: store.state.newJobPageState.jobs,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClientSearchTextChanged: (text) => store.dispatch(FilterClientList(store.state.newJobPageState, text)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
      onJobTitleTextChanged: (jobTitle) => store.dispatch(SetJobTitleAction(store.state.newJobPageState, jobTitle)),
      onPriceProfileSelected: (priceProfile) => store.dispatch(SetSelectedPriceProfile(store.state.newJobPageState, priceProfile)),
      onLocationSelected: (location) => store.dispatch(SetSelectedLocation(store.state.newJobPageState, location)),
      onDateSelected: (selectedDate) => store.dispatch(SetSelectedDateAction(store.state.newJobPageState, selectedDate)),
      onJobStageSelected: (jobStage) => store.dispatch(SetSelectedJobStageAction(store.state.newJobPageState, jobStage)),
      onJobTypeSelected: (jobType) => store.dispatch(SetSelectedJobTypeAction(store.state.newJobPageState, jobType)),
      onTimeSelected: (time) => store.dispatch(SetSelectedTimeAction(store.state.newJobPageState, time)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isFinishedFetchingClients.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
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
      jobTypeIcon.hashCode ^
      currentJobStage.hashCode ^
      upcomingJobs.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClientSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      onLocationSelected.hashCode ^
      onDateSelected.hashCode ^
      onJobStageSelected.hashCode ^
      eventMap.hashCode ^
      jobs.hashCode ^
      onTimeSelected.hashCode ^
      onJobClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobPageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          errorState == other.errorState &&
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
          jobTypeIcon == other.jobTypeIcon &&
          currentJobStage == other.currentJobStage &&
          upcomingJobs == other.upcomingJobs &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onClientSelected == other.onClientSelected &&
          onClientSearchTextChanged == other.onClientSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected &&
          onDateSelected == other.onDateSelected &&
          onJobStageSelected == other.onJobStageSelected &&
          eventMap == other.eventMap &&
          jobs == other.jobs &&
          onTimeSelected == other.onTimeSelected &&
          onJobClicked == other.onJobClicked;
}
