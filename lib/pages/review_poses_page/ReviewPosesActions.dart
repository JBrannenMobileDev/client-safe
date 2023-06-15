import '../../models/Pose.dart';
import '../pose_group_page/GroupImage.dart';
import 'ReviewPosesPageState.dart';

class ClearReviewPosesStateAction {
  final ReviewPosesPageState pageState;
  ClearReviewPosesStateAction(this.pageState);
}

class ApprovePoseAction {
  final ReviewPosesPageState pageState;
  final Pose pose;
  ApprovePoseAction(this.pageState, this.pose);
}

class RejectPoseAction {
  final ReviewPosesPageState pageState;
  final Pose pose;
  RejectPoseAction(this.pageState, this.pose);
}

class LoadPosesToReviewAction {
  final ReviewPosesPageState pageState;
  LoadPosesToReviewAction(this.pageState);
}

class SetPoseImagesToState {
  final ReviewPosesPageState pageState;
  final List<Pose> poses;
  final List<GroupImage> groupImages;
  SetPoseImagesToState(this.pageState, this.poses, this.groupImages);
}

