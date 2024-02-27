import '../../models/Pose.dart';
import '../../models/PoseSubmittedGroup.dart';
import '../pose_group_page/GroupImage.dart';
import 'SelectAPhotoPageState.dart';

class ClearReviewPosesStateAction {
  final SelectAPhotoPageState pageState;
  ClearReviewPosesStateAction(this.pageState);
}

class ApprovePoseAction {
  final SelectAPhotoPageState pageState;
  final Pose pose;
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
  ApprovePoseAction(this.pageState, this.pose, this.prompt, this.tags, this.engagementsSelected, this.familiesSelected,
      this.couplesSelected, this.portraitsSelected, this.maternitySelected, this.newbornSelected, this.proposalsSelected, this.petsSelected, this.weddingsSelected);
}

class RejectPoseAction {
  final SelectAPhotoPageState pageState;
  final Pose pose;
  RejectPoseAction(this.pageState, this.pose);
}

class LoadPosesToReviewAction {
  final SelectAPhotoPageState pageState;
  LoadPosesToReviewAction(this.pageState);
}

class SetPoseImagesToState {
  final SelectAPhotoPageState pageState;
  final List<Pose> poses;
  SetPoseImagesToState(this.pageState, this.poses);
}

class SetGroupsToStateAction {
  final SelectAPhotoPageState pageState;
  final List<PoseSubmittedGroup> groups;
  SetGroupsToStateAction(this.pageState, this.groups);
}

class UpdateGroupImageAction {
  final SelectAPhotoPageState pageState;
  final GroupImage groupImage;
  UpdateGroupImageAction(this.pageState, this.groupImage);
}

