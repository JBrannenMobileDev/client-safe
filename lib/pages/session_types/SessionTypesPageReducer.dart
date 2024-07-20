import 'package:redux/redux.dart';

import 'SessionTypesActions.dart';
import 'SessionTypesPageState.dart';

final sessionTypesPageReducer = combineReducers<SessionTypesPageState>([
  TypedReducer<SessionTypesPageState, SetSessionTypesAction>(_setJobTypes),
]);

SessionTypesPageState _setJobTypes(SessionTypesPageState previousState, SetSessionTypesAction action){
  return previousState.copyWith(
    sessionType: action.sessionTypes
  );
}
