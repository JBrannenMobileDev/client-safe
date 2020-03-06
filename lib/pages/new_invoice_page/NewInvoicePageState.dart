import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewInvoicePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool isFinishedFetchingClients;
  final Job selectedJob;
  final String jobSearchText;
  final List<Job> jobs;
  final List<Job> filteredJobs;
  final List<Client> allClients;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Job) onJobSelected;
  final Function(String) onJobSearchTextChanged;
  final Function() onClearInputSelected;

  NewInvoicePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.isFinishedFetchingClients,
    @required this.selectedJob,
    @required this.jobSearchText,
    @required this.jobs,
    @required this.filteredJobs,
    @required this.allClients,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onJobSelected,
    @required this.onJobSearchTextChanged,
    @required this.onClearInputSelected,
  });

  NewInvoicePageState copyWith({
    int id,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    Job selectedJob,
    String jobSearchText,
    List<Job> jobs,
    List<Job> filteredJobs,
    List<Client> allClients,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Job) onJobSelected,
    Function(String) onJobSearchTextChanged,
    Function() onClearInputSelected,
  }){
    return NewInvoicePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      selectedJob: selectedJob ?? this.selectedJob,
      jobSearchText: jobSearchText ?? this.jobSearchText,
      jobs: jobs ?? this.jobs,
      filteredJobs:  filteredJobs ?? this.filteredJobs,
      allClients: allClients?? this.allClients,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onJobSelected: onJobSelected ?? this.onJobSelected,
      onJobSearchTextChanged: onJobSearchTextChanged ?? this.onJobSearchTextChanged,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
    );
  }

  factory NewInvoicePageState.initial() {
    List<JobStage> selectedStagesInitial = List();
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1));
    return NewInvoicePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        selectedJob: null,
        jobSearchText: '',
        jobs: List(),
        filteredJobs: List(),
        allClients: List(),
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onJobSelected: null,
        onJobSearchTextChanged: null,
        onClearInputSelected: null,
      );
  }

  factory NewInvoicePageState.fromStore(Store<AppState> store) {
    return NewInvoicePageState(
      id: store.state.newJobPageState.id,
      pageViewIndex: store.state.newJobPageState.pageViewIndex,
      saveButtonEnabled: store.state.newJobPageState.saveButtonEnabled,
      shouldClear: store.state.newJobPageState.shouldClear,
      isFinishedFetchingClients: store.state.newJobPageState.isFinishedFetchingClients,
      selectedJob: store.state.newInvoicePageState.selectedJob,
      jobSearchText: store.state.newInvoicePageState.jobSearchText,
      jobs: store.state.newJobPageState.jobs,
      filteredJobs: store.state.newInvoicePageState.filteredJobs,
      allClients: store.state.newInvoicePageState.allClients,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onJobSelected: null,
      onJobSearchTextChanged: null,
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isFinishedFetchingClients.hashCode ^
      selectedJob.hashCode ^
      jobSearchText.hashCode ^
      filteredJobs.hashCode ^
      allClients.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onJobSelected.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      jobs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewInvoicePageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          selectedJob == other.selectedJob &&
          jobSearchText == other.jobSearchText &&
          filteredJobs == other.filteredJobs &&
          allClients == other.allClients &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onJobSelected == other.onJobSelected &&
          onJobSearchTextChanged == other.onJobSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected &&
          jobs == other.jobs;
}
