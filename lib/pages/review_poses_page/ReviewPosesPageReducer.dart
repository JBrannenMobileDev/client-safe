import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:redux/redux.dart';
import 'ReviewPosesActions.dart';
import 'ReviewPosesPageState.dart';



final reviewPosesReducer = combineReducers<ReviewPosesPageState>([
  TypedReducer<ReviewPosesPageState, ClearReviewPosesStateAction>(_clearState),
  TypedReducer<ReviewPosesPageState, SetPoseImagesToState>(_setPoses),
  TypedReducer<ReviewPosesPageState, SetGroupsToStateAction>(_setGroups),
  TypedReducer<ReviewPosesPageState, UpdateGroupImageAction>(_updateGroupImage),
]);

ReviewPosesPageState _updateGroupImage(ReviewPosesPageState previousState, UpdateGroupImageAction action){
  previousState.groupImages.forEach((group) {
    if(group.pose.documentId == action.groupImage.pose.documentId) {
      group.pose.reviewStatus = action.groupImage.pose.reviewStatus;
    }
  });
  return previousState.copyWith(
    groupImages: previousState.groupImages,
  );
}

ReviewPosesPageState _setGroups(ReviewPosesPageState previousState, SetGroupsToStateAction action){
  return previousState.copyWith(
      groups: action.groups,
  );
}

ReviewPosesPageState _setPoses(ReviewPosesPageState previousState, SetPoseImagesToState action){
  List<GroupImage> sorted = action.groupImages;
  sorted.sort();
  return previousState.copyWith(
      poses: action.poses,
      groupImages: sorted,
  );
}

ReviewPosesPageState _clearState(ReviewPosesPageState previousState, ClearReviewPosesStateAction action){
  return ReviewPosesPageState.initial();
}