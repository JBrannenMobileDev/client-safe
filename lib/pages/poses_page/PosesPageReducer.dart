import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:redux/redux.dart';

final posesReducer = combineReducers<PosesPageState>([
  TypedReducer<PosesPageState, SetPoseGroupsAction>(_setPoseGroups),
  TypedReducer<PosesPageState, SetPoseLibraryGroupsAction>(_setPoseLibraryGroups),
]);

PosesPageState _setPoseGroups(PosesPageState previousState, SetPoseGroupsAction action){
  return previousState.copyWith(
      poseGroups: action.poseGroups,
      groupImages: action.imageFiles,
  );
}

PosesPageState _setPoseLibraryGroups(PosesPageState previousState, SetPoseLibraryGroupsAction action){
  return previousState.copyWith(
    libraryGroups: action.poseGroups,
    libraryGroupImages: action.imageFiles,
  );
}

