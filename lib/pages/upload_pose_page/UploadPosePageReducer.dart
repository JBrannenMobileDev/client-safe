import 'package:dandylight/pages/upload_pose_page/UploadPoseActions.dart';
import 'package:redux/redux.dart';

import 'UploadPosePageState.dart';



final uploadPoseReducer = combineReducers<UploadPosePageState>([
  TypedReducer<UploadPosePageState, SetInstagramNameAction>(_setInstagramName),
  TypedReducer<UploadPosePageState, ClearStateAction>(_clearState),
  TypedReducer<UploadPosePageState, SetResizedImageAction>(_setResizedImage),
]);

UploadPosePageState _setResizedImage(UploadPosePageState previousState, SetResizedImageAction action){
  return previousState.copyWith(
      resizedImage500: action.resizedImage500,
  );
}

UploadPosePageState _setInstagramName(UploadPosePageState previousState, SetInstagramNameAction action){
  return UploadPosePageState.initial().copyWith(
      instagramName: action.instagramName
  );
}

UploadPosePageState _clearState(UploadPosePageState previousState, ClearStateAction action){
  return UploadPosePageState.initial();
}