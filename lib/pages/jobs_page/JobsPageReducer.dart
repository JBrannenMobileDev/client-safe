import 'package:client_safe/pages/jobs_page/JobsPageActions.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/utils/JobUtil.dart';
import 'package:redux/redux.dart';

final jobsPageReducer = combineReducers<JobsPageState>([
  TypedReducer<JobsPageState, SetJobsDataAction>(_setJobData),
  TypedReducer<JobsPageState, FilterChangedAction>(_updateFilterSelection),
]);

JobsPageState _setJobData(JobsPageState previousState, SetJobsDataAction action){
  action.jobs.sort((job1, job2) => job1.getMillisecondsUntilJob().compareTo(job2.getMillisecondsUntilJob()));
  return previousState.copyWith(
      jobsInProgress: JobUtil.getJobsInProgress(action.jobs),
      jobsCompleted: JobUtil.getJobsCompleted(action.jobs),
      allJobs: action.jobs,
  );
}

JobsPageState _updateFilterSelection(JobsPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}