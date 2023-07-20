

import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../models/Profile.dart';
import '../pose_group_page/GroupImage.dart';
import 'PosesActions.dart';

class PosesPageState{
  final List<PoseGroup> poseGroups;
  final List<PoseLibraryGroup> libraryGroups;
  final List<Pose> searchResultPoses;
  final List<Pose> allLibraryPoses;
  final List<Pose> sortedSubmittedPoses;
  final List<Pose> savedPoses;
  final List<Job> activeJobs;
  final String searchInput;
  final Profile profile;
  final bool shouldClear;
  final bool isAdmin;
  final Function(String) onSearchInputChanged;
  final Function(Pose, PoseGroup) onImageSaveSelected;
  final Function(Pose, Job) onImageAddedToJobSelected;

  PosesPageState({
    @required this.poseGroups,
    @required this.shouldClear,
    @required this.libraryGroups,
    @required this.isAdmin,
    @required this.searchInput,
    @required this.onSearchInputChanged,
    @required this.onImageAddedToJobSelected,
    @required this.onImageSaveSelected,
    @required this.activeJobs,
    @required this.allLibraryPoses,
    @required this.searchResultPoses,
    @required this.sortedSubmittedPoses,
    @required this.profile,
    @required this.savedPoses,
  });

  PosesPageState copyWith({
    List<PoseGroup> poseGroups,
    List<PoseLibraryGroup> libraryGroups,
    bool shouldClear,
    bool isAdmin,
    String searchInput,
    Function(String) onSearchInputChanged,
    Function(Pose, PoseGroup) onImageSaveSelected,
    Function(Pose, Job) onImageAddedToJobSelected,
    List<Job> activeJobs,
    List<Pose> allLibraryPoses,
    bool isLoadingSearchImages,
    List<Pose> searchResultPoses,
    List<Pose> sortedSubmittedPoses,
    bool isLoadingSubmittedPoses,
    Profile profile,
    List<Pose> savedPoses,
  }){
    return PosesPageState(
      poseGroups: poseGroups?? this.poseGroups,
      shouldClear: shouldClear?? this.shouldClear,
      libraryGroups: libraryGroups ?? this.libraryGroups,
      isAdmin: isAdmin ?? this.isAdmin,
      searchInput: searchInput ?? this.searchInput,
      onSearchInputChanged: onSearchInputChanged ?? this.onSearchInputChanged,
      onImageAddedToJobSelected: onImageAddedToJobSelected ?? this.onImageAddedToJobSelected,
      onImageSaveSelected: onImageSaveSelected ?? this.onImageSaveSelected,
      activeJobs: activeJobs ?? this.activeJobs,
      allLibraryPoses: allLibraryPoses ?? this.allLibraryPoses,
      searchResultPoses: searchResultPoses ?? this.searchResultPoses,
      sortedSubmittedPoses: sortedSubmittedPoses ?? this.sortedSubmittedPoses,
      profile: profile ?? this.profile,
      savedPoses: savedPoses ?? this.savedPoses,
    );
  }

  factory PosesPageState.initial() => PosesPageState(
    poseGroups: [],
    libraryGroups: [],
    shouldClear: true,
    isAdmin: false,
    searchInput: '',
    onSearchInputChanged: null,
    onImageSaveSelected: null,
    onImageAddedToJobSelected: null,
    activeJobs: [],
    allLibraryPoses: [],
    searchResultPoses: [],
    sortedSubmittedPoses: [],
    profile: null,
    savedPoses: [],
  );

  factory PosesPageState.fromStore(Store<AppState> store) {
    return PosesPageState(
      poseGroups: store.state.posesPageState.poseGroups,
      shouldClear: store.state.posesPageState.shouldClear,
      libraryGroups: store.state.posesPageState.libraryGroups,
      isAdmin: store.state.posesPageState.isAdmin,
      searchInput: store.state.posesPageState.searchInput,
      activeJobs: store.state.posesPageState.activeJobs,
      allLibraryPoses: store.state.posesPageState.allLibraryPoses,
      searchResultPoses: store.state.posesPageState.searchResultPoses,
      sortedSubmittedPoses: store.state.posesPageState.sortedSubmittedPoses,
      profile: store.state.posesPageState.profile,
      savedPoses: store.state.posesPageState.savedPoses,
      onSearchInputChanged: (searchInput) => store.dispatch(UpdateSearchInputAction(store.state.posesPageState, searchInput)),
      onImageSaveSelected: (pose, poseGroup) => store.dispatch(SavePoseToMyPosesAction(store.state.posesPageState, pose, poseGroup)),
      onImageAddedToJobSelected: (pose, job) => store.dispatch(SaveImageToJobAction(store.state.posesPageState, pose, job)),
    );
  }

  @override
  int get hashCode =>
      poseGroups.hashCode ^
      shouldClear.hashCode ^
      libraryGroups.hashCode ^
      isAdmin.hashCode ^
      searchInput.hashCode ^
      onSearchInputChanged.hashCode ^
      onImageSaveSelected.hashCode ^
      onImageAddedToJobSelected.hashCode ^
      activeJobs.hashCode ^
      allLibraryPoses.hashCode ^
      searchResultPoses.hashCode ^
      sortedSubmittedPoses.hashCode ^
      savedPoses.hashCode ^
      profile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PosesPageState &&
              poseGroups == other.poseGroups &&
              shouldClear == other.shouldClear &&
              libraryGroups == other.libraryGroups &&
              isAdmin == other.isAdmin &&
              searchInput == other.searchInput &&
              onSearchInputChanged == other.onSearchInputChanged &&
              onImageSaveSelected == other.onImageSaveSelected &&
              onImageAddedToJobSelected == other.onImageAddedToJobSelected &&
              activeJobs == other.activeJobs &&
              allLibraryPoses == other.allLibraryPoses &&
              searchResultPoses == other.searchResultPoses &&
              profile == other.profile &&
              sortedSubmittedPoses == other.sortedSubmittedPoses &&
              savedPoses == other.savedPoses;
}