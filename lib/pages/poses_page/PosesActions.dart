import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';

import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../models/Profile.dart';
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
  SetPoseGroupsAction(this.pageState, this.poseGroups);
}

class SetPoseLibraryGroupsAction{
  final PosesPageState pageState;
  final List<PoseLibraryGroup> poseGroups;
  SetPoseLibraryGroupsAction(this.pageState, this.poseGroups);
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
  final Pose selectedImage;
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

class SetPosesProfileAction {
  final PosesPageState pageState;
  final Profile profile;
  SetPosesProfileAction(this.pageState, this.profile);
}

class SetAllPosesAction {
  final PosesPageState pageState;
  final List<Pose> allPoses;
  SetAllPosesAction(this.pageState, this.allPoses);
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

class SetSortedSubmittedPosesAction {
  final PosesPageState pageState;
  final List<Pose> submittedPoses;
  SetSortedSubmittedPosesAction(this.pageState, this.submittedPoses);
}

class ClearPosesPageStateAction {
  final PosesPageState pageState;
  ClearPosesPageStateAction(this.pageState);
}
