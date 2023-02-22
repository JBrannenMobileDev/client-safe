

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
  final PoseLibraryGroup poseGroup;
  final Function(List<XFile>, String, String, List<String>) onNewPoseImagesSelected;
  final Function() onBackSelected;
  final List<GroupImage> poseImages;
  final List<Job> activeJobs;
  final List<PoseGroup> myPoseGroups;
  final List<File> myPoseGroupImages;
  final Function(GroupImage, PoseGroup) onImageSaveSelected;
  final Function(Pose, Job) onImageAddedToJobSelected;
  final bool isLoadingNewImages;
  final bool isAdmin;
  final String instagramName;
  final String instagramUrl;


  LibraryPoseGroupPageState({
    @required this.poseGroup,
    @required this.onNewPoseImagesSelected,
    @required this.onBackSelected,
    @required this.poseImages,
    @required this.isLoadingNewImages,
    @required this.onImageAddedToJobSelected,
    @required this.onImageSaveSelected,
    @required this.isAdmin,
    @required this.activeJobs,
    @required this.myPoseGroups,
    @required this.myPoseGroupImages,
    @required this.instagramUrl,
    @required this.instagramName,
  });

  LibraryPoseGroupPageState copyWith({
    PoseLibraryGroup poseGroup,
    Function(List<XFile>, String, List<String>) onNewPoseImagesSelected,
    Function() onBackSelected,
    List<GroupImage> poseImages,
    Function(GroupImage, PoseGroup) onImageSaveSelected,
    Function(Pose, Job) onImageAddedToJobSelected,
    bool isLoadingNewImages,
    bool isAdmin,
    List<Job> activeJobs,
    List<PoseGroup> myPoseGroups,
    List<File> myPoseGroupImages,
    String instagramName,
    String instagramUrl,
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
      activeJobs: activeJobs ?? this.activeJobs,
      myPoseGroups: myPoseGroups ?? this.myPoseGroups,
      myPoseGroupImages: myPoseGroupImages ?? this.myPoseGroupImages,
      instagramName: instagramName ?? this.instagramName,
      instagramUrl: instagramUrl ?? this.instagramUrl,
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
    activeJobs: [],
    myPoseGroups: [],
    myPoseGroupImages: [],
    instagramUrl: '',
    instagramName: '',
  );

  factory LibraryPoseGroupPageState.fromStore(Store<AppState> store) {
    return LibraryPoseGroupPageState(
      poseGroup: store.state.libraryPoseGroupPageState.poseGroup,
      poseImages: store.state.libraryPoseGroupPageState.poseImages,
      isLoadingNewImages: store.state.libraryPoseGroupPageState.isLoadingNewImages,
      isAdmin: store.state.libraryPoseGroupPageState.isAdmin,
      activeJobs: store.state.libraryPoseGroupPageState.activeJobs,
      myPoseGroups: store.state.libraryPoseGroupPageState.myPoseGroups,
      myPoseGroupImages: store.state.libraryPoseGroupPageState.myPoseGroupImages,
      instagramName: store.state.libraryPoseGroupPageState.instagramName,
      instagramUrl: store.state.libraryPoseGroupPageState.instagramUrl,
      onNewPoseImagesSelected: (poseImages, name, url, tags) => {
        store.dispatch(SetLoadingNewLibraryImagesState(store.state.libraryPoseGroupPageState, true)),
        store.dispatch(SaveLibraryPosesToGroupAction(store.state.libraryPoseGroupPageState, poseImages, name, url, tags)),
      },
      onBackSelected: () {
        store.dispatch(ClearLibraryPoseGroupState(store.state.libraryPoseGroupPageState));
      },
      onImageSaveSelected: (groupImage, poseGroup) => store.dispatch(SaveSelectedPoseToMyPosesAction(store.state.libraryPoseGroupPageState, groupImage, poseGroup)),
      onImageAddedToJobSelected: (pose, job) => store.dispatch(SaveSelectedImageToJobAction(store.state.libraryPoseGroupPageState, pose, job)),
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
      activeJobs.hashCode ^
      myPoseGroups.hashCode ^
      myPoseGroupImages.hashCode ^
      instagramName.hashCode ^
      instagramUrl.hashCode ^
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
              activeJobs == other.activeJobs &&
              myPoseGroups == other.myPoseGroups &&
              myPoseGroupImages == other.myPoseGroupImages &&
              instagramName == other.instagramName &&
              instagramUrl == other.instagramUrl &&
              poseGroup == other.poseGroup;
}