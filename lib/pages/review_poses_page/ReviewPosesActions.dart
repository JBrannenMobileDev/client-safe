import '../../models/Pose.dart';
import '../../models/PoseSubmittedGroup.dart';
import '../pose_group_page/GroupImage.dart';
import 'ReviewPosesPageState.dart';

class ClearReviewPosesStateAction {
  final ReviewPosesPageState pageState;
  ClearReviewPosesStateAction(this.pageState);
}

class ApprovePoseAction {
  final ReviewPosesPageState pageState;
  final GroupImage groupImage;
  final String prompt;
  final String tags;
  final bool engagementsSelected;
  final bool couplesSelected;
  final bool familiesSelected;
  final bool portraitsSelected;
  final bool maternitySelected;
  final bool newbornSelected;
  final bool proposalsSelected;
  final bool petsSelected;
  final bool weddingsSelected;
  ApprovePoseAction(this.pageState, this.groupImage, this.prompt, this.tags, this.engagementsSelected, this.couplesSelected,
      this.familiesSelected, this.portraitsSelected, this.maternitySelected, this.newbornSelected, this.proposalsSelected, this.petsSelected, this.weddingsSelected);
}

class RejectPoseAction {
  final ReviewPosesPageState pageState;
  final GroupImage groupImage;
  RejectPoseAction(this.pageState, this.groupImage);
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

class SetGroupsToStateAction {
  final ReviewPosesPageState pageState;
  final List<PoseSubmittedGroup> groups;
  SetGroupsToStateAction(this.pageState, this.groups);
}

class UpdateGroupImageAction {
  final ReviewPosesPageState pageState;
  final GroupImage groupImage;
  UpdateGroupImageAction(this.pageState, this.groupImage);
}

