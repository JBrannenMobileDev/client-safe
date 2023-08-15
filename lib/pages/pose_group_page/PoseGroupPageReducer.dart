import 'package:dandylight/pages/pose_group_page/PoseGroupActions.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:redux/redux.dart';

final poseGroupReducer = combineReducers<PoseGroupPageState>([
  TypedReducer<PoseGroupPageState, SetPoseGroupData>(_setPoseGroup),
  TypedReducer<PoseGroupPageState, SetPoseImagesToState>(_setPoseImages),
  TypedReducer<PoseGroupPageState, ClearPoseGroupState>(_clearState),
  TypedReducer<PoseGroupPageState, SetActiveJobsToPoses>(_setActiveJobs),
]);

PoseGroupPageState _setActiveJobs(PoseGroupPageState previousState, SetActiveJobsToPoses action){
  return previousState.copyWith(
    activeJobs: action.activeJobs,
  );
}

PoseGroupPageState _clearState(PoseGroupPageState previousState, ClearPoseGroupState action){
  return PoseGroupPageState.initial();
}

PoseGroupPageState _setPoseGroup(PoseGroupPageState previousState, SetPoseGroupData action){
  return previousState.copyWith(
      poseGroup: action.poseGroup,
  );
}

PoseGroupPageState _setPoseImages(PoseGroupPageState previousState, SetPoseImagesToState action){
  return previousState.copyWith(
    poseImages: action.poseImages,
  );
}
