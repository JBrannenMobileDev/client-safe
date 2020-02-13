import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:redux/redux.dart';

final jobDetailsReducer = combineReducers<JobDetailsPageState>([
  TypedReducer<JobDetailsPageState, SetJobInfo>(_setJobInfo),
]);

JobDetailsPageState _setJobInfo(JobDetailsPageState previousState, SetJobInfo action){
  return previousState.copyWith(
    job: action.job,
  );
}