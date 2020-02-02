import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/jobs_page/JobsPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'JobsPage.dart';

class JobsPageState {
  final String filterType;
  final Job selectedJob;
  final List<Job> leads;
  final List<Job> jobsInProgress;
  final List<Job> jobsCompleted;
  final Function(String) onFilterChanged;
  final Function(Job) onJobClicked;
  final Function() fetchJobs;

  JobsPageState({
    @required this.filterType,
    @required this.selectedJob,
    @required this.leads,
    @required this.jobsInProgress,
    @required this.jobsCompleted,
    @required this.onFilterChanged,
    @required this.onJobClicked,
    @required this.fetchJobs,
  });

  JobsPageState copyWith({
    String filterType,
    Job selectedClient,
    List<Job> leads,
    List<Job> jobsInProgress,
    List<Job> jobsCompleted,
    Function(String) onFilterChanged,
    Function(String) onJobClicked,
    Function() fetchJobs,
  }){
    return JobsPageState(
      filterType: filterType?? this.filterType,
      selectedJob: selectedClient?? this.selectedJob,
      leads: leads?? this.leads,
      jobsInProgress: jobsInProgress?? this.jobsInProgress,
      jobsCompleted: jobsCompleted?? this.jobsCompleted,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onJobClicked: jobsCompleted?? this.onJobClicked,
      fetchJobs: fetchJobs?? this.fetchJobs,
    );
  }

  factory JobsPageState.initial() => JobsPageState(
    filterType: JobsPage.FILTER_TYPE_IN_PROGRESS,
    selectedJob: null,
    leads: List(),
    jobsInProgress: List(),
    jobsCompleted: List(),
    onFilterChanged: null,
    onJobClicked: null,
    fetchJobs: null,
  );

  factory JobsPageState.fromStore(Store<AppState> store) {
    return JobsPageState(
      filterType: store.state.jobsPageState.filterType,
      selectedJob: store.state.jobsPageState.selectedJob,
      leads: store.state.jobsPageState.leads,
      jobsInProgress: store.state.jobsPageState.jobsInProgress,
      jobsCompleted: store.state.jobsPageState.jobsCompleted,
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.jobsPageState, filterType)),
//      onJobClicked: (client) => store.dispatch(InitializeJobDetailsAction(store.state.clientDetailsPageState, client)),
      onJobClicked: (job) => null,
      fetchJobs: () => store.dispatch(FetchJobsAction(store.state.jobsPageState)),
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      selectedJob.hashCode ^
      leads.hashCode ^
      jobsInProgress.hashCode ^
      jobsCompleted.hashCode ^
      onFilterChanged.hashCode ^
      onJobClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobsPageState &&
              filterType == other.filterType &&
              selectedJob == other.selectedJob &&
              leads == other.leads &&
              jobsInProgress == other.jobsInProgress &&
              jobsCompleted == other.jobsCompleted &&
              onFilterChanged == other.onFilterChanged &&
              onJobClicked == other.onJobClicked;
}
