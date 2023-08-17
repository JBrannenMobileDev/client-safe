import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:redux/redux.dart';
import 'ReviewPosesActions.dart';
import 'ReviewPosesPageState.dart';



final reviewPosesReducer = combineReducers<ReviewPosesPageState>([
  TypedReducer<ReviewPosesPageState, ClearReviewPosesStateAction>(_clearState),
  TypedReducer<ReviewPosesPageState, SetPoseImagesToState>(_setPoses),
  TypedReducer<ReviewPosesPageState, SetGroupsToStateAction>(_setGroups),
]);

ReviewPosesPageState _setGroups(ReviewPosesPageState previousState, SetGroupsToStateAction action){
  return previousState.copyWith(
      groups: action.groups,
  );
}

ReviewPosesPageState _setPoses(ReviewPosesPageState previousState, SetPoseImagesToState action){
  return previousState.copyWith(
      poses: action.poses,
  );
}

ReviewPosesPageState _clearState(ReviewPosesPageState previousState, ClearReviewPosesStateAction action){
  return ReviewPosesPageState.initial();
}