import 'package:redux/redux.dart';

import 'UploadPosePageState.dart';



final uploadPoseReducer = combineReducers<UploadPosePageState>([
  // TypedReducer<UploadPosePageState, SetLibraryPoseGroupData>(_setPoseGroup),
]);
//
// UploadPosePageState _clearImages(UploadPosePageState previousState, ClearLibraryGroupImagesAction action){
//   return UploadPosePageState.initial();
// }