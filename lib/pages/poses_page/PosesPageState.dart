

import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../pose_group_page/GroupImage.dart';
import 'PosesActions.dart';

class PosesPageState{
  final List<PoseGroup> poseGroups;
  final List<PoseLibraryGroup> libraryGroups;
  final List<File> groupImages;
  final List<File> libraryGroupImages;
  final List<GroupImage> searchResultsImages;
  final List<Pose> allLibraryPoses;
  final List<File> allLibraryPoseImages;
  final List<Job> activeJobs;
  final String searchInput;
  final bool shouldClear;
  final bool isAdmin;
  final Function(String) onSearchInputChanged;
  final Function(GroupImage, PoseGroup) onImageSaveSelected;
  final Function(Pose, Job) onImageAddedToJobSelected;

  PosesPageState({
    @required this.poseGroups,
    @required this.shouldClear,
    @required this.groupImages,
    @required this.libraryGroups,
    @required this.libraryGroupImages,
    @required this.isAdmin,
    @required this.searchInput,
    @required this.searchResultsImages,
    @required this.onSearchInputChanged,
    @required this.onImageAddedToJobSelected,
    @required this.onImageSaveSelected,
    @required this.activeJobs,
    @required this.allLibraryPoseImages,
    @required this.allLibraryPoses,
  });

  PosesPageState copyWith({
    List<PoseGroup> poseGroups,
    List<PoseLibraryGroup> libraryGroups,
    List<File> libraryGroupImages,
    bool shouldClear,
    List<File> groupImages,
    bool isAdmin,
    List<GroupImage> searchResultsImages,
    String searchInput,
    Function(String) onSearchInputChanged,
    Function(GroupImage, PoseGroup) onImageSaveSelected,
    Function(Pose, Job) onImageAddedToJobSelected,
    List<Job> activeJobs,
    List<Pose> allLibraryPoses,
    List<File> allLibraryPoseImages,
  }){
    return PosesPageState(
      poseGroups: poseGroups?? this.poseGroups,
      shouldClear: shouldClear?? this.shouldClear,
      groupImages: groupImages ?? this.groupImages,
      libraryGroups: libraryGroups ?? this.libraryGroups,
      libraryGroupImages: libraryGroupImages ?? this.libraryGroupImages,
      isAdmin: isAdmin ?? this.isAdmin,
      searchResultsImages: searchResultsImages ?? this.searchResultsImages,
      searchInput: searchInput ?? this.searchInput,
      onSearchInputChanged: onSearchInputChanged ?? this.onSearchInputChanged,
      onImageAddedToJobSelected: onImageAddedToJobSelected ?? this.onImageAddedToJobSelected,
      onImageSaveSelected: onImageSaveSelected ?? this.onImageSaveSelected,
      activeJobs: activeJobs ?? this.activeJobs,
      allLibraryPoseImages: allLibraryPoseImages ?? this.allLibraryPoseImages,
      allLibraryPoses: allLibraryPoses ?? this.allLibraryPoses,
    );
  }

  factory PosesPageState.initial() => PosesPageState(
    poseGroups: [],
    libraryGroups: [],
    groupImages: [],
    libraryGroupImages: [],
    shouldClear: true,
    isAdmin: false,
    searchResultsImages: [],
    searchInput: '',
    onSearchInputChanged: null,
    onImageSaveSelected: null,
    onImageAddedToJobSelected: null,
    activeJobs: [],
    allLibraryPoses: [],
    allLibraryPoseImages: [],
  );

  factory PosesPageState.fromStore(Store<AppState> store) {
    return PosesPageState(
      poseGroups: store.state.posesPageState.poseGroups,
      groupImages: store.state.posesPageState.groupImages,
      shouldClear: store.state.posesPageState.shouldClear,
      libraryGroups: store.state.posesPageState.libraryGroups,
      libraryGroupImages: store.state.posesPageState.libraryGroupImages,
      isAdmin: store.state.posesPageState.isAdmin,
      searchResultsImages: store.state.posesPageState.searchResultsImages,
      searchInput: store.state.posesPageState.searchInput,
      activeJobs: store.state.posesPageState.activeJobs,
      allLibraryPoseImages: store.state.posesPageState.allLibraryPoseImages,
      allLibraryPoses: store.state.posesPageState.allLibraryPoses,
      onSearchInputChanged: (searchInput) => store.dispatch(UpdateSearchInputAction(store.state.posesPageState, searchInput)),
      onImageSaveSelected: (groupImage, poseGroup) => store.dispatch(SavePoseToMyPosesAction(store.state.posesPageState, groupImage, poseGroup)),
      onImageAddedToJobSelected: (pose, job) => store.dispatch(SaveImageToJobAction(store.state.posesPageState, pose, job)),
    );
  }

  @override
  int get hashCode =>
      poseGroups.hashCode ^
      shouldClear.hashCode ^
      groupImages.hashCode ^
      libraryGroups.hashCode ^
      isAdmin.hashCode ^
      searchResultsImages.hashCode ^
      searchInput.hashCode ^
      onSearchInputChanged.hashCode ^
      onImageSaveSelected.hashCode ^
      onImageAddedToJobSelected.hashCode ^
      activeJobs.hashCode ^
      allLibraryPoseImages.hashCode ^
      allLibraryPoses.hashCode ^
      libraryGroupImages.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PosesPageState &&
              poseGroups == other.poseGroups &&
              shouldClear == other.shouldClear &&
              groupImages == other.groupImages &&
              libraryGroups == other.libraryGroups &&
              isAdmin == other.isAdmin &&
              searchResultsImages == other.searchResultsImages &&
              searchInput == other.searchInput &&
              onSearchInputChanged == other.onSearchInputChanged &&
              onImageSaveSelected == other.onImageSaveSelected &&
              onImageAddedToJobSelected == other.onImageAddedToJobSelected &&
              activeJobs == other.activeJobs &&
              allLibraryPoseImages == other.allLibraryPoseImages &&
              allLibraryPoses == other.allLibraryPoses &&
              libraryGroupImages == other.libraryGroupImages;
}