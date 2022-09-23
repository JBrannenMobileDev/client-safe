import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';

class FetchPoseGroupsAction{
  final PosesPageState pageState;
  FetchPoseGroupsAction(this.pageState);
}

class SetPoseGroupsAction{
  final PosesPageState pageState;
  final List<PoseGroup> poseGroups;
  final List<File> imageFiles;
  SetPoseGroupsAction(this.pageState, this.poseGroups, this.imageFiles);
}
