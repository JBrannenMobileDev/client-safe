import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import 'JobsPage.dart';

class JobsPageState {
  final String? filterType;
  final Job? selectedJob;
  final List<Job>? leads;
  final List<Job>? activeJobs;
  final List<Job>? jobsCompleted;
  final Function(String)? onFilterChanged;

  JobsPageState({
    @required this.filterType,
    @required this.selectedJob,
    @required this.leads,
    @required this.activeJobs,
    @required this.jobsCompleted,
    @required this.onFilterChanged,
  });

  JobsPageState copyWith({
    String? filterType,
    Job? selectedJob,
    List<Job>? leads,
    List<Job>? activeJobs,
    List<Job>? jobsCompleted,
    Function(String)? onFilterChanged,
  }){
    return JobsPageState(
      filterType: filterType?? this.filterType,
      selectedJob: selectedJob?? this.selectedJob,
      leads: leads?? this.leads,
      activeJobs: activeJobs?? this.activeJobs,
      jobsCompleted: jobsCompleted?? this.jobsCompleted,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
    );
  }

  factory JobsPageState.initial() => JobsPageState(
    filterType: JobsPage.FILTER_TYPE_ACTIVE_JOBS,
    selectedJob: null,
    leads: [],
    activeJobs: [],
    jobsCompleted: [],
    onFilterChanged: null,
  );

  factory JobsPageState.fromStore(Store<AppState> store) {
    return JobsPageState(
      filterType: store.state.jobsPageState!.filterType,
      selectedJob: store.state.jobsPageState!.selectedJob,
      leads: store.state.jobsPageState!.leads,
      activeJobs: store.state.jobsPageState!.activeJobs,
      jobsCompleted: store.state.jobsPageState!.jobsCompleted,
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.jobsPageState, filterType)),
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      selectedJob.hashCode ^
      leads.hashCode ^
      activeJobs.hashCode ^
      jobsCompleted.hashCode ^
      onFilterChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobsPageState &&
              filterType == other.filterType &&
              selectedJob == other.selectedJob &&
              leads == other.leads &&
              activeJobs == other.activeJobs &&
              jobsCompleted == other.jobsCompleted &&
              onFilterChanged == other.onFilterChanged;
}
