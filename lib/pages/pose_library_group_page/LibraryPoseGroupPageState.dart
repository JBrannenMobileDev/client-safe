

import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../pose_group_page/GroupImage.dart';
import 'LibraryPoseGroupActions.dart';

class LibraryPoseGroupPageState{
  final PoseLibraryGroup poseGroup;
  final Function(List<XFile>) onNewPoseImagesSelected;
  final Function() onBackSelected;
  final List<GroupImage> poseImages;
  final Function(GroupImage) onImageSaveSelected;
  final Function(GroupImage, Job) onImageAddedToJobSelected;
  final bool isLoadingNewImages;
  final bool isAdmin;


  LibraryPoseGroupPageState({
    @required this.poseGroup,
    @required this.onNewPoseImagesSelected,
    @required this.onBackSelected,
    @required this.poseImages,
    @required this.isLoadingNewImages,
    @required this.onImageAddedToJobSelected,
    @required this.onImageSaveSelected,
    @required this.isAdmin,
  });

  LibraryPoseGroupPageState copyWith({
    PoseLibraryGroup poseGroup,
    Function(List<XFile>) onNewPoseImagesSelected,
    Function() onBackSelected,
    List<GroupImage> poseImages,
    Function(GroupImage) onImageSaveSelected,
    Function(GroupImage, Job) onImageAddedToJobSelected,
    bool isLoadingNewImages,
    bool isAdmin,
  }){
    return LibraryPoseGroupPageState(
      poseGroup: poseGroup ?? this.poseGroup,
      poseImages: poseImages ?? this.poseImages,
      onNewPoseImagesSelected: onNewPoseImagesSelected ?? this.onNewPoseImagesSelected,
      onBackSelected:  onBackSelected ?? this.onBackSelected,
      isLoadingNewImages: isLoadingNewImages ?? this.isLoadingNewImages,
      onImageAddedToJobSelected: onImageAddedToJobSelected ?? this.onImageAddedToJobSelected,
      onImageSaveSelected: onImageSaveSelected ?? this.onImageSaveSelected,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  factory LibraryPoseGroupPageState.initial() => LibraryPoseGroupPageState(
    poseGroup: null,
    onNewPoseImagesSelected: null,
    onBackSelected: null,
    poseImages: [],
    isLoadingNewImages: false,
    onImageSaveSelected: null,
    onImageAddedToJobSelected: null,
    isAdmin: false,
  );

  factory LibraryPoseGroupPageState.fromStore(Store<AppState> store) {
    return LibraryPoseGroupPageState(
      poseGroup: store.state.libraryPoseGroupPageState.poseGroup,
      poseImages: store.state.libraryPoseGroupPageState.poseImages,
      isLoadingNewImages: store.state.libraryPoseGroupPageState.isLoadingNewImages,
      isAdmin: store.state.libraryPoseGroupPageState.isAdmin,
      onNewPoseImagesSelected: (poseImages) => {
        store.dispatch(SetLoadingNewLibraryImagesState(store.state.libraryPoseGroupPageState, true)),
        store.dispatch(SaveLibraryPosesToGroupAction(store.state.libraryPoseGroupPageState, poseImages)),
      },
      onBackSelected: () {
        store.dispatch(ClearLibraryPoseGroupState(store.state.libraryPoseGroupPageState));
      },
      onImageSaveSelected: (groupImage) => null,
      onImageAddedToJobSelected: (groupImage, job) => null,
    );
  }

  @override
  int get hashCode =>
      poseGroup.hashCode ^
      poseImages.hashCode ^
      onNewPoseImagesSelected.hashCode ^
      onBackSelected.hashCode ^
      onImageSaveSelected.hashCode ^
      onImageAddedToJobSelected.hashCode ^
      isAdmin.hashCode ^
      isLoadingNewImages.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LibraryPoseGroupPageState &&
              poseImages == other.poseImages &&
              onBackSelected == other.onBackSelected &&
              onNewPoseImagesSelected == other.onNewPoseImagesSelected &&
              isLoadingNewImages == other.isLoadingNewImages &&
              onImageSaveSelected == other.onImageSaveSelected &&
              onImageAddedToJobSelected == other.onImageAddedToJobSelected &&
              isAdmin == other.isAdmin &&
              poseGroup == other.poseGroup;
}