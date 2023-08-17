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
  final List<Pose> poses;
  final List<PoseSubmittedGroup> groups;
  final Function(Pose, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApproveSelected;
  final Function(Pose) onRejectedSelected;

  ReviewPosesPageState({
    @required this.onApproveSelected,
    @required this.onRejectedSelected,
    @required this.instagramName,
    @required this.poses,
    @required this.groups,
  });

  ReviewPosesPageState copyWith({
    String instagramName,
    List<Pose> poses,
    List<PoseSubmittedGroup> groups,
    Function(Pose, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApprovedSelected,
    Function(Pose) onRejectedSelected,
  }){
    return ReviewPosesPageState(
      onApproveSelected: onApproveSelected ?? this.onApproveSelected,
      onRejectedSelected: onRejectedSelected ?? this.onRejectedSelected,
      instagramName: instagramName ?? this.instagramName,
      poses: poses ?? this.poses,
      groups: groups ?? this.groups,
    );
  }

  factory ReviewPosesPageState.initial() => ReviewPosesPageState(
    onApproveSelected: null,
    onRejectedSelected: null,
    instagramName: '',
    poses: [],
    groups: [],
  );

  factory ReviewPosesPageState.fromStore(Store<AppState> store) {
    return ReviewPosesPageState(
      instagramName: store.state.reviewPosesPageState.instagramName,
      poses: store.state.reviewPosesPageState.poses,
      groups: store.state.reviewPosesPageState.groups,
      onApproveSelected: (pose, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(ApprovePoseAction(store.state.reviewPosesPageState, pose, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
      onRejectedSelected: (pose) => {
        store.dispatch(RejectPoseAction(store.state.reviewPosesPageState, pose)),
      }
    );
  }

  @override
  int get hashCode =>
      instagramName.hashCode ^
      onRejectedSelected.hashCode ^
      poses.hashCode ^
      onApproveSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ReviewPosesPageState &&
              instagramName == other.instagramName &&
              onApproveSelected == other.onApproveSelected &&
              poses == other.poses &&
              onRejectedSelected == other.onRejectedSelected;
}