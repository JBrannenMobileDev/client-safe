import 'package:redux/redux.dart';
import '../review_poses_page/ReviewPosesActions.dart';
import 'SelectAPhotoPageState.dart';



final selectAPhotoReducer = combineReducers<SelectAPhotoPageState>([
  TypedReducer<SelectAPhotoPageState, ClearReviewPosesStateAction>(_clearState),
  TypedReducer<SelectAPhotoPageState, SetPoseImagesToState>(_setPoses),
  TypedReducer<SelectAPhotoPageState, SetGroupsToStateAction>(_setGroups),
]);

SelectAPhotoPageState _setGroups(SelectAPhotoPageState previousState, SetGroupsToStateAction action){
  return previousState.copyWith(
      groups: action.groups,
  );
}

SelectAPhotoPageState _setPoses(SelectAPhotoPageState previousState, SetPoseImagesToState action){
  return previousState.copyWith(
      poses: action.poses,
  );
}

SelectAPhotoPageState _clearState(SelectAPhotoPageState previousState, ClearReviewPosesStateAction action){
  return SelectAPhotoPageState.initial();
}