import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import '../pose_group_page/GroupImage.dart';
import 'ReviewPosesActions.dart';

class ReviewPosesPageState{
  final String instagramName;
  final List<GroupImage> groupImages;
  final List<Pose> poses;
  final Function(Pose) onApproveSelected;
  final Function(Pose) onRejectedSelected;

  ReviewPosesPageState({
    @required this.onApproveSelected,
    @required this.onRejectedSelected,
    @required this.instagramName,
    @required this.groupImages,
    @required this.poses,
  });

  ReviewPosesPageState copyWith({
    String instagramName,
    List<GroupImage> groupImages,
    List<Pose> poses,
    Function(Pose) onApprovedSelected,
    Function(Pose) onRejectedSelected,
  }){
    return ReviewPosesPageState(
      onApproveSelected: onApproveSelected ?? this.onApproveSelected,
      onRejectedSelected: onRejectedSelected ?? this.onRejectedSelected,
      instagramName: instagramName ?? this.instagramName,
      groupImages: groupImages ?? this.groupImages,
      poses: poses ?? this.poses,
    );
  }

  factory ReviewPosesPageState.initial() => ReviewPosesPageState(
    onApproveSelected: null,
    onRejectedSelected: null,
    instagramName: '',
    groupImages: [],
    poses: [],
  );

  factory ReviewPosesPageState.fromStore(Store<AppState> store) {
    return ReviewPosesPageState(
      instagramName: store.state.reviewPosesPageState.instagramName,
      groupImages: store.state.reviewPosesPageState.groupImages,
      poses: store.state.reviewPosesPageState.poses,
      onApproveSelected: (pose) => {
        store.dispatch(ApprovePoseAction(store.state.reviewPosesPageState, pose)),
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