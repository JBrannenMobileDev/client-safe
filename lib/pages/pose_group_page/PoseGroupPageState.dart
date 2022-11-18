

import 'package:dandylight/models/Pose.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../poses_page/PosesActions.dart';
import 'GroupImage.dart';
import 'PoseGroupActions.dart';

class PoseGroupPageState{
  final PoseGroup poseGroup;
  final Function(List<XFile>) onNewPoseImagesSelected;
  final Function(GroupImage) onDeletePoseSelected;
  final Function() onDeletePoseGroupSelected;
  final Function() onSharePosesSelected;
  final Function() onBackSelected;
  final List<GroupImage> poseImages;
  final List<GroupImage> selectedImages;
  final Function(bool) onSelectAllSelected;
  final Function(GroupImage) onImageChecked;
  final Function() onDeletePosesSelected;
  final bool isLoadingNewImages;


  PoseGroupPageState({
    @required this.poseGroup,
    @required this.onNewPoseImagesSelected,
    @required this.onDeletePoseSelected,
    @required this.onDeletePoseGroupSelected,
    @required this.onSharePosesSelected,
    @required this.onBackSelected,
    @required this.poseImages,
    @required this.selectedImages,
    @required this.onSelectAllSelected,
    @required this.onImageChecked,
    @required this.onDeletePosesSelected,
    @required this.isLoadingNewImages,
  });

  PoseGroupPageState copyWith({
    PoseGroup poseGroup,
    Function(List<XFile>) onNewPoseImagesSelected,
    Function(GroupImage) onDeletePoseSelected,
    Function() onDeletePoseGroupSelected,
    Function() onSharePosesSelected,
    Function() onBackSelected,
    List<GroupImage> poseImages,
    List<GroupImage> selectedImages,
    Function(bool) onSelectAllSelected,
    Function(GroupImage) onImageChecked,
    Function() onDeletePosesSelected,
    bool isLoadingNewImages,
  }){
    return PoseGroupPageState(
      poseGroup: poseGroup ?? this.poseGroup,
      onDeletePoseSelected: onDeletePoseSelected ?? this.onDeletePoseSelected,
      onDeletePoseGroupSelected: onDeletePoseGroupSelected ?? this.onDeletePoseGroupSelected,
      onSharePosesSelected: onSharePosesSelected ?? this.onSharePosesSelected,
      poseImages: poseImages ?? this.poseImages,
      onNewPoseImagesSelected: onNewPoseImagesSelected ?? this.onNewPoseImagesSelected,
      onBackSelected:  onBackSelected ?? this.onBackSelected,
      selectedImages: selectedImages ?? this.selectedImages,
      onSelectAllSelected: onSelectAllSelected ?? this.onSelectAllSelected,
      onImageChecked: onImageChecked ?? this.onImageChecked,
      onDeletePosesSelected: onDeletePosesSelected ?? this.onDeletePosesSelected,
      isLoadingNewImages: isLoadingNewImages ?? this.isLoadingNewImages,
    );
  }

  factory PoseGroupPageState.initial() => PoseGroupPageState(
    poseGroup: null,
    onDeletePoseSelected: null,
    onDeletePoseGroupSelected: null,
    onSharePosesSelected: null,
    onNewPoseImagesSelected: null,
    onBackSelected: null,
    poseImages: [],
    selectedImages: [],
    onSelectAllSelected: null,
    onImageChecked: null,
    onDeletePosesSelected: null,
    isLoadingNewImages: false,
  );

  factory PoseGroupPageState.fromStore(Store<AppState> store) {
    return PoseGroupPageState(
      poseGroup: store.state.poseGroupPageState.poseGroup,
      poseImages: store.state.poseGroupPageState.poseImages,
      selectedImages: store.state.poseGroupPageState.selectedImages,
      isLoadingNewImages: store.state.poseGroupPageState.isLoadingNewImages,
      onSelectAllSelected: (checked) => store.dispatch(SetSelectAllState(store.state.poseGroupPageState, checked)),
      onImageChecked: (image) => store.dispatch(SetSinglePoseSelected(store.state.poseGroupPageState, image)),
      onDeletePosesSelected: () => store.dispatch(DeleteSelectedPoses(store.state.poseGroupPageState)),
      onDeletePoseSelected: (pose) => store.dispatch(DeletePoseAction(store.state.poseGroupPageState, pose)),
      onDeletePoseGroupSelected: () => store.dispatch(DeletePoseGroupSelected(store.state.poseGroupPageState)),
      onSharePosesSelected: () => store.dispatch(SharePosesAction(store.state.poseGroupPageState)),
      onNewPoseImagesSelected: (poseImages) => {
        store.dispatch(SetLoadingNewImagesState(store.state.poseGroupPageState, true)),
        store.dispatch(SavePosesToGroupAction(store.state.poseGroupPageState, poseImages)),
      },
      onBackSelected: () {
        store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
        },
    );
  }

  @override
  int get hashCode =>
      poseGroup.hashCode ^
      poseImages.hashCode ^
      onDeletePoseSelected.hashCode ^
      onSharePosesSelected.hashCode ^
      onNewPoseImagesSelected.hashCode ^
      onBackSelected.hashCode ^
      selectedImages.hashCode ^
      onSelectAllSelected.hashCode ^
      onImageChecked.hashCode ^
      onDeletePosesSelected.hashCode ^
      isLoadingNewImages.hashCode ^
      onDeletePoseGroupSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PoseGroupPageState &&
              poseImages == other.poseImages &&
              onDeletePoseGroupSelected == onDeletePoseGroupSelected &&
              onDeletePoseSelected == other.onDeletePoseSelected &&
              onSharePosesSelected == other.onSharePosesSelected &&
              onBackSelected == other.onBackSelected &&
              onNewPoseImagesSelected == other.onNewPoseImagesSelected &&
              selectedImages == other.selectedImages &&
              onSelectAllSelected == other.onSelectAllSelected &&
              onImageChecked == other.onImageChecked &&
              onDeletePosesSelected == other.onDeletePosesSelected &&
              isLoadingNewImages == other.isLoadingNewImages &&
              poseGroup == other.poseGroup;
}