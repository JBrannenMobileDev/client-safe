import 'package:dandylight/pages/pose_group_page/PoseGroupActions.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import 'GroupImage.dart';

final poseGroupReducer = combineReducers<PoseGroupPageState>([
  TypedReducer<PoseGroupPageState, SetPoseGroupData>(_setPoseGroup),
  TypedReducer<PoseGroupPageState, SetPoseImagesToState>(_setPoseImages),
  TypedReducer<PoseGroupPageState, ClearPoseGroupState>(_clearState),
  TypedReducer<PoseGroupPageState, SetSelectAllState>(_setSelectedImages),
  TypedReducer<PoseGroupPageState, SetSinglePoseSelected>(_setSelectedImage),
]);

PoseGroupPageState _setSelectedImage(PoseGroupPageState previousState, SetSinglePoseSelected action){
  bool selectedImagesContainNewSelection = previousState.selectedImages.contains(action.selectedPose);
  List<GroupImage> resultList = previousState.selectedImages;
  if(selectedImagesContainNewSelection) {
    resultList.remove(action.selectedPose);
  } else {
    resultList.add(action.selectedPose);
  }
  return previousState.copyWith(
    selectedImages: resultList,
  );
}

PoseGroupPageState _setSelectedImages(PoseGroupPageState previousState, SetSelectAllState action){
  return previousState.copyWith(
    selectedImages: action.checked ? previousState.poseImages : [],
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
