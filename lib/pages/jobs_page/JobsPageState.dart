import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
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

  JobsPageState({
    @required this.filterType,
    @required this.selectedJob,
    @required this.leads,
    @required this.jobsInProgress,
    @required this.jobsCompleted,
    @required this.onFilterChanged,
    @required this.onJobClicked,
  });

  JobsPageState copyWith({
    String filterType,
    Job selectedJob,
    List<Job> leads,
    List<Job> jobsInProgress,
    List<Job> jobsCompleted,
    Function(String) onFilterChanged,
    Function(String) onJobClicked,
  }){
    return JobsPageState(
      filterType: filterType?? this.filterType,
      selectedJob: selectedJob?? this.selectedJob,
      leads: leads?? this.leads,
      jobsInProgress: jobsInProgress?? this.jobsInProgress,
      jobsCompleted: jobsCompleted?? this.jobsCompleted,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onJobClicked: onJobClicked?? this.onJobClicked,
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
  );

  factory JobsPageState.fromStore(Store<AppState> store) {
    return JobsPageState(
      filterType: store.state.jobsPageState.filterType,
      selectedJob: store.state.jobsPageState.selectedJob,
      leads: store.state.jobsPageState.leads,
      jobsInProgress: store.state.jobsPageState.jobsInProgress,
      jobsCompleted: store.state.jobsPageState.jobsCompleted,
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.jobsPageState, filterType)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
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
