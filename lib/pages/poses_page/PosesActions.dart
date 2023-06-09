import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';

import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../pose_group_page/GroupImage.dart';

class FetchPoseGroupsAction{
  final PosesPageState pageState;
  FetchPoseGroupsAction(this.pageState);
}

class ClearPoseSearchPageAction {
  final PosesPageState pageState;
  ClearPoseSearchPageAction(this.pageState);
}

class SetPoseGroupsAction{
  final PosesPageState pageState;
  final List<PoseGroup> poseGroups;
  final List<File> imageFiles;
  SetPoseGroupsAction(this.pageState, this.poseGroups, this.imageFiles);
}

class SetPoseLibraryGroupsAction{
  final PosesPageState pageState;
  final List<PoseLibraryGroup> poseGroups;
  final List<File> imageFiles;
  SetPoseLibraryGroupsAction(this.pageState, this.poseGroups, this.imageFiles);
}

class SetIsAdminAction {
  final PosesPageState pageState;
  final bool isAdmin;
  SetIsAdminAction(this.pageState, this.isAdmin);
}

class UpdateSearchInputAction {
  final PosesPageState pageState;
  final String searchInput;
  UpdateSearchInputAction(this.pageState, this.searchInput);
}

class SavePoseToMyPosesAction {
  final PosesPageState pageState;
  final GroupImage selectedImage;
  final PoseGroup selectedGroup;
  SavePoseToMyPosesAction(this.pageState, this.selectedImage, this.selectedGroup);
}

class SaveImageToJobAction {
  final PosesPageState pageState;
  final Pose selectedPose;
  final Job selectedJob;
  SaveImageToJobAction(this.pageState, this.selectedPose, this.selectedJob);
}

class FetchMyPoseGroupsAction {
  final PosesPageState pageState;
  FetchMyPoseGroupsAction(this.pageState);
}

class SetActiveJobsToPosesPage {
  final PosesPageState pageState;
  final List<Job> activeJobs;
  SetActiveJobsToPosesPage(this.pageState, this.activeJobs);
}

class SetAllPosesAction {
  final PosesPageState pageState;
  final List<Pose> allPoses;
  final List<GroupImage> allImages;
  SetAllPosesAction(this.pageState, this.allPoses, this.allImages);
}

class SetSearchResultPosesAction {
  final PosesPageState pageState;
  final List<GroupImage> searchResultImages;
  SetSearchResultPosesAction(this.pageState, this.searchResultImages);
}

class SetSubmittedPosesAction {
  final PosesPageState pageState;
  final List<GroupImage> submittedPoses;
  SetSubmittedPosesAction(this.pageState, this.submittedPoses);
}

class SetLoadingNewSearchResultImagesState {
  final PosesPageState pageState;
  final bool isLoadingSearchImages;
  SetLoadingNewSearchResultImagesState(this.pageState, this.isLoadingSearchImages);
}

class LoadMorePoseImagesAction {
  final PosesPageState pageState;
  LoadMorePoseImagesAction(this.pageState);
}

class SetLoadingSubmittedPosesState {
  final PosesPageState pageState;
  final bool isLoading;
  SetLoadingSubmittedPosesState(this.pageState, this.isLoading);
}

class LoadMoreSubmittedImagesAction {
  final PosesPageState pageState;
  LoadMoreSubmittedImagesAction(this.pageState);
}

class SetSortedSubmittedPosesAction {
  final PosesPageState pageState;
  final List<Pose> submittedPoses;
  SetSortedSubmittedPosesAction(this.pageState, this.submittedPoses);
}
