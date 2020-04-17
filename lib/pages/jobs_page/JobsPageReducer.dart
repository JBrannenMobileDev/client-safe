import 'package:client_safe/pages/jobs_page/JobsPage.dart';
import 'package:client_safe/pages/jobs_page/JobsPageActions.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/utils/JobUtil.dart';
import 'package:redux/redux.dart';

final jobsPageReducer = combineReducers<JobsPageState>([
  TypedReducer<JobsPageState, SetJobsDataAction>(_setJobData),
  TypedReducer<JobsPageState, FilterChangedAction>(_updateFilterSelection),
]);

JobsPageState _setJobData(JobsPageState previousState, SetJobsDataAction action){
  action.jobs.sort((job1, job2) => job1.selectedDate?.millisecondsSinceEpoch?.compareTo(job2.selectedDate?.millisecondsSinceEpoch ?? 0) ?? 0);
  return previousState.copyWith(
      jobsInProgress: JobUtil.getJobsInProgress(action.jobs),
      jobsCompleted: JobUtil.getJobsCompleted(action.jobs),
      jobsUpcoming: JobUtil.getUpComingJobs(action.jobs),
      filterType: JobsPage.FILTER_TYPE_UPCOMING,
  );
}

JobsPageState _updateFilterSelection(JobsPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}