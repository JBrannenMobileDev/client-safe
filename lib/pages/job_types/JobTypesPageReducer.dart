import 'package:redux/redux.dart';

import 'JobTypesActions.dart';
import 'JobTypesPageState.dart';

final jobTypesPageReducer = combineReducers<JobTypesPageState>([
  TypedReducer<JobTypesPageState, SetJobTypesAction>(_setJobTypes),
]);

JobTypesPageState _setJobTypes(JobTypesPageState previousState, SetJobTypesAction action){
  return previousState.copyWith(
    jobTypes: action.jobTypes
  );
}
