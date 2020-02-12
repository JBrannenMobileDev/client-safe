import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:redux/redux.dart';

final jobDetailsReducer = combineReducers<JobDetailsPageState>([
  TypedReducer<JobDetailsPageState, ScrollOffsetChangedAction>(_setOffset),
]);

JobDetailsPageState _setOffset(JobDetailsPageState previousState, ScrollOffsetChangedAction action){
  return previousState.copyWith(
    stageScrollOffset: action.offset,
  );
}