import 'package:dandylight/pages/upload_pose_page/UploadPoseActions.dart';
import 'package:redux/redux.dart';

import 'ReviewPosesPageState.dart';



final reviewPosesReducer = combineReducers<ReviewPosesPageState>([
  TypedReducer<ReviewPosesPageState, SetInstagramNameAction>(_setInstagramName),
  TypedReducer<ReviewPosesPageState, ClearStateAction>(_clearState),
]);

ReviewPosesPageState _setInstagramName(ReviewPosesPageState previousState, SetInstagramNameAction action){
  return previousState.copyWith(
    instagramName: action.instagramName
  );
}

ReviewPosesPageState _clearState(ReviewPosesPageState previousState, ClearStateAction action){
  return ReviewPosesPageState.initial();
}