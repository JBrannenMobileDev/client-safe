

import 'dart:io';

import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import '../pose_group_page/GroupImage.dart';
import 'LibraryPoseGroupActions.dart';

class LibraryPoseGroupPageState{
  final PoseLibraryGroup? poseGroup;
  final Function()? onBackSelected;
  final List<Job>? activeJobs;
  final List<PoseGroup>? myPoseGroups;
  final List<Pose>? sortedPoses;
  final Function(List<XFile>, String, String, List<String>)? onNewPoseImagesSelected;
  final List<GroupImage>? poseImages;
  final Function(Pose, PoseGroup)? onImageSaveSelected;
  final Function(Pose, Job)? onImageAddedToJobSelected;
  final bool? isAdmin;
  final String? instagramName;
  final String? instagramUrl;

  LibraryPoseGroupPageState({
    @required this.onNewPoseImagesSelected,
    @required this.poseImages,
    @required this.poseGroup,
    @required this.onBackSelected,
    @required this.onImageAddedToJobSelected,
    @required this.onImageSaveSelected,
    @required this.isAdmin,
    @required this.activeJobs,
    @required this.myPoseGroups,
    @required this.instagramUrl,
    @required this.instagramName,
    @required this.sortedPoses,
  });

  LibraryPoseGroupPageState copyWith({
    Function(List<XFile>, String, String, List<String>)? onNewPoseImagesSelected,
    List<GroupImage>? poseImages,
    PoseLibraryGroup? poseGroup,
    Function()? onBackSelected,
    Function(Pose, PoseGroup)? onImageSaveSelected,
    Function(Pose, Job)? onImageAddedToJobSelected,
    bool? isAdmin,
    List<Job>? activeJobs,
    List<PoseGroup>? myPoseGroups,
    String? instagramName,
    String? instagramUrl,
    List<Pose>? sortedPoses,
  }){
    return LibraryPoseGroupPageState(
      poseGroup: poseGroup ?? this.poseGroup,
      onBackSelected:  onBackSelected ?? this.onBackSelected,
      onImageAddedToJobSelected: onImageAddedToJobSelected ?? this.onImageAddedToJobSelected,
      onImageSaveSelected: onImageSaveSelected ?? this.onImageSaveSelected,
      isAdmin: isAdmin ?? this.isAdmin,
      activeJobs: activeJobs ?? this.activeJobs,
      myPoseGroups: myPoseGroups ?? this.myPoseGroups,
      instagramName: instagramName ?? this.instagramName,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      sortedPoses: sortedPoses ?? this.sortedPoses,
      poseImages: poseImages ?? this.poseImages,
      onNewPoseImagesSelected: onNewPoseImagesSelected ?? this.onNewPoseImagesSelected,
    );
  }

  factory LibraryPoseGroupPageState.initial() => LibraryPoseGroupPageState(
    poseGroup: null,
    onBackSelected: null,
    onImageSaveSelected: null,
    onImageAddedToJobSelected: null,
    isAdmin: false,
    activeJobs: [],
    myPoseGroups: [],
    instagramUrl: '',
    instagramName: '',
    sortedPoses: [],
    onNewPoseImagesSelected: null,
    poseImages: [],
  );

  factory LibraryPoseGroupPageState.fromStore(Store<AppState> store) {
    return LibraryPoseGroupPageState(
      poseGroup: store.state.libraryPoseGroupPageState!.poseGroup,
      isAdmin: store.state.libraryPoseGroupPageState!.isAdmin,
      activeJobs: store.state.libraryPoseGroupPageState!.activeJobs,
      myPoseGroups: store.state.libraryPoseGroupPageState!.myPoseGroups,
      instagramName: store.state.libraryPoseGroupPageState!.instagramName,
      instagramUrl: store.state.libraryPoseGroupPageState!.instagramUrl,
      sortedPoses: store.state.libraryPoseGroupPageState!.sortedPoses,
      poseImages: store.state.libraryPoseGroupPageState!.poseImages,
      onNewPoseImagesSelected: (poseImages, name, url, tags) => {
        store.dispatch(SaveLibraryPosesToGroupAction(store.state.libraryPoseGroupPageState, poseImages, name, url, tags)),
      },
      onBackSelected: () {
        store.dispatch(ClearLibraryPoseGroupState(store.state.libraryPoseGroupPageState));
      },
      onImageSaveSelected: (pose, poseGroup) => store.dispatch(SaveSelectedPoseToMyPosesAction(store.state.libraryPoseGroupPageState, pose, poseGroup)),
      onImageAddedToJobSelected: (pose, job) => store.dispatch(SaveSelectedImageToJobAction(store.state.libraryPoseGroupPageState, pose, job))
    );
  }

  @override
  int get hashCode =>
      poseGroup.hashCode ^
      onBackSelected.hashCode ^
      onImageSaveSelected.hashCode ^
      onImageAddedToJobSelected.hashCode ^
      isAdmin.hashCode ^
      poseImages.hashCode ^
      onNewPoseImagesSelected.hashCode ^
      activeJobs.hashCode ^
      myPoseGroups.hashCode ^
      instagramName.hashCode ^
      instagramUrl.hashCode ^
      sortedPoses.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LibraryPoseGroupPageState &&
              onBackSelected == other.onBackSelected &&
              onImageSaveSelected == other.onImageSaveSelected &&
              onImageAddedToJobSelected == other.onImageAddedToJobSelected &&
              isAdmin == other.isAdmin &&
              poseImages == other.poseImages &&
              onNewPoseImagesSelected == other.onNewPoseImagesSelected &&
              activeJobs == other.activeJobs &&
              myPoseGroups == other.myPoseGroups &&
              instagramName == other.instagramName &&
              instagramUrl == other.instagramUrl &&
              sortedPoses == other.sortedPoses &&
              poseGroup == other.poseGroup;
}