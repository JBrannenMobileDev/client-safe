import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'JobsPage.dart';

class JobsPageState {
  final String filterType;
  final Job selectedJob;
  final List<Job> leads;
  final List<Job> jobsInProgress;
  final List<Job> jobsCompleted;
  final List<Job> jobsUpcoming;
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
    @required this.jobsUpcoming,
  });

  JobsPageState copyWith({
    String filterType,
    Job selectedJob,
    List<Job> leads,
    List<Job> jobsInProgress,
    List<Job> jobsCompleted,
    List<Job> jobsUpcoming,
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
      jobsUpcoming: jobsUpcoming ?? this.jobsUpcoming,
    );
  }

  factory JobsPageState.initial() => JobsPageState(
    filterType: JobsPage.FILTER_TYPE_UPCOMING,
    selectedJob: null,
    leads: List(),
    jobsInProgress: List(),
    jobsCompleted: List(),
    onFilterChanged: null,
    onJobClicked: null,
    jobsUpcoming: List(),
  );

  factory JobsPageState.fromStore(Store<AppState> store) {
    return JobsPageState(
      filterType: store.state.jobsPageState.filterType,
      selectedJob: store.state.jobsPageState.selectedJob,
      leads: store.state.jobsPageState.leads,
      jobsInProgress: store.state.jobsPageState.jobsInProgress,
      jobsCompleted: store.state.jobsPageState.jobsCompleted,
      jobsUpcoming: store.state.jobsPageState.jobsUpcoming,
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
      jobsUpcoming.hashCode ^
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
              jobsUpcoming == other.jobsUpcoming &&
              onJobClicked == other.onJobClicked;
}
