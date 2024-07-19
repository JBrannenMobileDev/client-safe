import 'package:redux/redux.dart';

import 'SessionTypesActions.dart';
import 'SessionTypesPageState.dart';

final sessionTypesPageReducer = combineReducers<SessionTypesPageState>([
  TypedReducer<SessionTypesPageState, SetJobTypesAction>(_setJobTypes),
]);

SessionTypesPageState _setJobTypes(SessionTypesPageState previousState, SetJobTypesAction action){
  return previousState.copyWith(
    jobTypes: action.jobTypes
  );
}
