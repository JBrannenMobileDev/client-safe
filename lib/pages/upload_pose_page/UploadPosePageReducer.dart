import 'package:dandylight/pages/upload_pose_page/UploadPoseActions.dart';
import 'package:redux/redux.dart';

import 'UploadPosePageState.dart';



final uploadPoseReducer = combineReducers<UploadPosePageState>([
  TypedReducer<UploadPosePageState, SetInstagramNameAction>(_setInstagramName),
]);

UploadPosePageState _setInstagramName(UploadPosePageState previousState, SetInstagramNameAction action){
  return previousState.copyWith(
    instagramName: action.instagramName
  );
}