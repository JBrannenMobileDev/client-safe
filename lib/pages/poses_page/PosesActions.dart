import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';

import '../../models/PoseLibraryGroup.dart';

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

