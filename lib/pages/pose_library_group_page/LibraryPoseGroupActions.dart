import 'dart:io';

import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../pose_group_page/GroupImage.dart';
import 'LibraryPoseGroupPageState.dart';

class SetActiveJobs {
  final LibraryPoseGroupPageState pageState;
  final List<Job> activeJobs;
  SetActiveJobs(this.pageState, this.activeJobs);
}

class SetLibraryPoseGroupData{
  final LibraryPoseGroupPageState pageState;
  final PoseLibraryGroup poseGroup;
  SetLibraryPoseGroupData(this.pageState, this.poseGroup);
}

class SaveLibraryPosesToGroupAction{
  final LibraryPoseGroupPageState pageState;
  final List<XFile> poseImages;
  final String name;
  final String url;
  final List<String> tags;
  SaveLibraryPosesToGroupAction(this.pageState, this.poseImages, this.name, this.url, this.tags);
}

class LoadLibraryPoseGroup{
  final LibraryPoseGroupPageState pageState;
  final PoseLibraryGroup poseGroup;
  LoadLibraryPoseGroup(this.pageState, this.poseGroup);
}

class SetLoadingNewLibraryImagesState{
  final LibraryPoseGroupPageState pageState;
  final bool isLoading;
  SetLoadingNewLibraryImagesState(this.pageState, this.isLoading);
}

class SetLibraryPoseImagesToState{
  final LibraryPoseGroupPageState pageState;
  final List<GroupImage> poseImages;
  SetLibraryPoseImagesToState(this.pageState, this.poseImages);
}

class SetInstagramAction {
  final LibraryPoseGroupPageState pageState;
  String instagramName;
  String instagramUrl;
  SetInstagramAction(this.pageState, this.instagramName, this.instagramUrl);
}

class ClearLibraryPoseGroupState{
  final LibraryPoseGroupPageState pageState;
  ClearLibraryPoseGroupState(this.pageState);
}

class SaveSelectedPoseToMyPosesAction {
  final LibraryPoseGroupPageState pageState;
  final Pose selectedImage;
  final PoseGroup selectedGroup;
  SaveSelectedPoseToMyPosesAction(this.pageState, this.selectedImage, this.selectedGroup);
}

class SaveSelectedImageToJobAction {
  final LibraryPoseGroupPageState pageState;
  final Pose selectedPose;
  final Job selectedJob;
  SaveSelectedImageToJobAction(this.pageState, this.selectedPose, this.selectedJob);
}

class SortGroupImages {
  final LibraryPoseGroupPageState pageState;
  final PoseLibraryGroup poseGroup;
  SortGroupImages(this.pageState, this.poseGroup);
}

class SetSortedPosesAction {
  final LibraryPoseGroupPageState pageState;
  final List<Pose> sortedPoses;
  SetSortedPosesAction(this.pageState, this.sortedPoses);
}

class FetchMyPoseGroupsForLibraryAction {
  final LibraryPoseGroupPageState pageState;
  FetchMyPoseGroupsForLibraryAction(this.pageState);
}

class SetIsAdminLibraryAction {
  final LibraryPoseGroupPageState pageState;
  final bool isAdmin;
  SetIsAdminLibraryAction(this.pageState, this.isAdmin);
}

class SetPoseGroupsLibraryAction{
  final LibraryPoseGroupPageState pageState;
  final List<PoseGroup> poseGroups;
  SetPoseGroupsLibraryAction(this.pageState, this.poseGroups);
}

