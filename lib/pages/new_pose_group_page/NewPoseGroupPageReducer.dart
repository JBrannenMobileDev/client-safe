
import 'package:redux/redux.dart';

import 'NewPoseGroupActions.dart';
import 'NewPoseGroupPageState.dart';

final newPoseGroupReducer = combineReducers<NewPoseGroupPageState>([
  TypedReducer<NewPoseGroupPageState, UpdateName>(_updateName),
  TypedReducer<NewPoseGroupPageState, ClearStateAction>(_clearState),
]);

NewPoseGroupPageState _updateName(NewPoseGroupPageState previousState, UpdateName action) {
  return previousState.copyWith(
    groupName: action.groupName,
  );
}

NewPoseGroupPageState _clearState(NewPoseGroupPageState previousState, ClearStateAction action) {
  return NewPoseGroupPageState.initial();
}
