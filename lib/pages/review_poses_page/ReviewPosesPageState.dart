import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import 'ReviewPosesActions.dart';

class ReviewPosesPageState{
  final String instagramName;
  final Function(Pose) onApproveSelected;
  final Function(Pose) onRejectedSelected;

  ReviewPosesPageState({
    @required this.onApproveSelected,
    @required this.onRejectedSelected,
    @required this.instagramName
  });

  ReviewPosesPageState copyWith({
    String instagramName,
    Function(Pose) onApprovedSelected,
    Function(Pose) onRejectedSelected,
  }){
    return ReviewPosesPageState(
      onApproveSelected: onApproveSelected ?? this.onApproveSelected,
      onRejectedSelected: onRejectedSelected ?? this.onRejectedSelected,
      instagramName: instagramName ?? this.instagramName,
    );
  }

  factory ReviewPosesPageState.initial() => ReviewPosesPageState(
    onApproveSelected: null,
    onRejectedSelected: null,
    instagramName: '',
  );

  factory ReviewPosesPageState.fromStore(Store<AppState> store) {
    return ReviewPosesPageState(
      instagramName: store.state.uploadPosePageState.instagramName,
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
      onApproveSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ReviewPosesPageState &&
              instagramName == other.instagramName &&
              onApproveSelected == other.onApproveSelected &&
              onRejectedSelected == other.onRejectedSelected;
}