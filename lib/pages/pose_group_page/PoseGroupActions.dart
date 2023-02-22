import 'dart:io';

import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import 'GroupImage.dart';

class DeletePoseAction{
  final PoseGroupPageState pageState;
  final GroupImage groupImage;
  DeletePoseAction(this.pageState, this.groupImage);
}

class DeletePoseGroupSelected{
  final PoseGroupPageState pageState;
  DeletePoseGroupSelected(this.pageState);
}

class SharePosesAction{
  final PoseGroupPageState pageState;
  SharePosesAction(this.pageState);
}

class SaveSelectedImageToJobFromPosesAction {
  final PoseGroupPageState pageState;
  final Pose selectedPose;
  final Job selectedJob;
  SaveSelectedImageToJobFromPosesAction(this.pageState, this.selectedPose, this.selectedJob);
}

class SetActiveJobsToPoses {
  final PoseGroupPageState pageState;
  final List<Job> activeJobs;
  SetActiveJobsToPoses(this.pageState, this.activeJobs);
}

class SavePosesToGroupAction{
  final PoseGroupPageState pageState;
  final List<XFile> poseImages;
  SavePosesToGroupAction(this.pageState, this.poseImages);
}

class SetPoseGroupData{
  final PoseGroupPageState pageState;
  final PoseGroup poseGroup;
  SetPoseGroupData(this.pageState, this.poseGroup);
}

class LoadPoseImagesFromStorage{
  final PoseGroupPageState pageState;
  final PoseGroup poseGroup;
  LoadPoseImagesFromStorage(this.pageState, this.poseGroup);
}

class SetPoseImagesToState{
  final PoseGroupPageState pageState;
  final List<GroupImage> poseImages;
  SetPoseImagesToState(this.pageState, this.poseImages);
}

class ClearPoseGroupState{
  final PoseGroupPageState pageState;
  ClearPoseGroupState(this.pageState);
}

class SetSelectAllState {
  final PoseGroupPageState pageState;
  final bool checked;
  SetSelectAllState(this.pageState, this.checked);
}

class DeleteSelectedPoses{
  final PoseGroupPageState pageState;
  DeleteSelectedPoses(this.pageState);
}

class SetSinglePoseSelected{
  final PoseGroupPageState pageState;
  final GroupImage selectedPose;
  SetSinglePoseSelected(this.pageState, this.selectedPose);
}

class SetLoadingNewImagesState{
  final PoseGroupPageState pageState;
  final bool isLoading;
  SetLoadingNewImagesState(this.pageState, this.isLoading);
}

