import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import '../../models/PoseSubmittedGroup.dart';
import 'SelectAPhotoActions.dart';

class SelectAPhotoPageState{
  final String instagramName;
  final List<Pose> poses;
  final List<PoseSubmittedGroup> groups;
  final Function(Pose, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApproveSelected;
  final Function(Pose) onRejectedSelected;

  SelectAPhotoPageState({
    @required this.onApproveSelected,
    @required this.onRejectedSelected,
    @required this.instagramName,
    @required this.poses,
    @required this.groups,
  });

  SelectAPhotoPageState copyWith({
    String instagramName,
    List<Pose> poses,
    List<PoseSubmittedGroup> groups,
    Function(Pose, String, String, bool, bool, bool, bool, bool, bool, bool, bool, bool) onApprovedSelected,
    Function(Pose) onRejectedSelected,
  }){
    return SelectAPhotoPageState(
      onApproveSelected: onApproveSelected ?? this.onApproveSelected,
      onRejectedSelected: onRejectedSelected ?? this.onRejectedSelected,
      instagramName: instagramName ?? this.instagramName,
      poses: poses ?? this.poses,
      groups: groups ?? this.groups,
    );
  }

  factory SelectAPhotoPageState.initial() => SelectAPhotoPageState(
    onApproveSelected: null,
    onRejectedSelected: null,
    instagramName: '',
    poses: [],
    groups: [],
  );

  factory SelectAPhotoPageState.fromStore(Store<AppState> store) {
    return SelectAPhotoPageState(
      instagramName: store.state.selectAPhotoPageState.instagramName,
      poses: store.state.selectAPhotoPageState.poses,
      groups: store.state.selectAPhotoPageState.groups,
      onApproveSelected: (pose, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(ApprovePoseAction(store.state.selectAPhotoPageState, pose, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
      onRejectedSelected: (pose) => {
        store.dispatch(RejectPoseAction(store.state.selectAPhotoPageState, pose)),
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
          other is SelectAPhotoPageState &&
              instagramName == other.instagramName &&
              onApproveSelected == other.onApproveSelected &&
              poses == other.poses &&
              onRejectedSelected == other.onRejectedSelected;
}