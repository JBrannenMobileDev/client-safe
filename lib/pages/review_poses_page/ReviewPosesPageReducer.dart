import 'package:redux/redux.dart';
import 'ReviewPosesActions.dart';
import 'ReviewPosesPageState.dart';



final reviewPosesReducer = combineReducers<ReviewPosesPageState>([
  TypedReducer<ReviewPosesPageState, ClearReviewPosesStateAction>(_clearState),
  TypedReducer<ReviewPosesPageState, SetPoseImagesToState>(_setPoses),
]);

ReviewPosesPageState _setPoses(ReviewPosesPageState previousState, SetPoseImagesToState action){
  return previousState.copyWith(
      poses: action.poses,
      groupImages: action.groupImages
  );
}

ReviewPosesPageState _clearState(ReviewPosesPageState previousState, ClearReviewPosesStateAction action){
  return ReviewPosesPageState.initial();
}