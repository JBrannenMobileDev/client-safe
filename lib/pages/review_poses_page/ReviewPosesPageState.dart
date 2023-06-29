import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import '../../models/PoseSubmittedGroup.dart';
import '../pose_group_page/GroupImage.dart';
import 'ReviewPosesActions.dart';

class ReviewPosesPageState{
  final String instagramName;
  final List<GroupImage> groupImages;
  final List<Pose> poses;
  final List<PoseSubmittedGroup> groups;
  final Function(GroupImage, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApproveSelected;
  final Function(GroupImage) onRejectedSelected;

  ReviewPosesPageState({
    @required this.onApproveSelected,
    @required this.onRejectedSelected,
    @required this.instagramName,
    @required this.groupImages,
    @required this.poses,
    @required this.groups,
  });

  ReviewPosesPageState copyWith({
    String instagramName,
    List<GroupImage> groupImages,
    List<Pose> poses,
    List<PoseSubmittedGroup> groups,
    Function(GroupImage, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApprovedSelected,
    Function(GroupImage) onRejectedSelected,
  }){
    return ReviewPosesPageState(
      onApproveSelected: onApproveSelected ?? this.onApproveSelected,
      onRejectedSelected: onRejectedSelected ?? this.onRejectedSelected,
      instagramName: instagramName ?? this.instagramName,
      groupImages: groupImages ?? this.groupImages,
      poses: poses ?? this.poses,
      groups: groups ?? this.groups,
    );
  }

  factory ReviewPosesPageState.initial() => ReviewPosesPageState(
    onApproveSelected: null,
    onRejectedSelected: null,
    instagramName: '',
    groupImages: [],
    poses: [],
    groups: [],
  );

  factory ReviewPosesPageState.fromStore(Store<AppState> store) {
    return ReviewPosesPageState(
      instagramName: store.state.reviewPosesPageState.instagramName,
      groupImages: store.state.reviewPosesPageState.groupImages,
      poses: store.state.reviewPosesPageState.poses,
      groups: store.state.reviewPosesPageState.groups,
      onApproveSelected: (groupImage, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(ApprovePoseAction(store.state.reviewPosesPageState, groupImage, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
      onRejectedSelected: (groupImage) => {
        store.dispatch(RejectPoseAction(store.state.reviewPosesPageState, groupImage)),
      }
    );
  }

  @override
  int get hashCode =>
      instagramName.hashCode ^
      onRejectedSelected.hashCode ^
      groupImages.hashCode ^
      poses.hashCode ^
      onApproveSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ReviewPosesPageState &&
              instagramName == other.instagramName &&
              onApproveSelected == other.onApproveSelected &&
              groupImages == other.groupImages &&
              poses == other.poses &&
              onRejectedSelected == other.onRejectedSelected;
}