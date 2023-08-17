

import 'package:dandylight/models/Pose.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import 'PoseGroupActions.dart';

class PoseGroupPageState{
  final PoseGroup poseGroup;
  final Function(List<XFile>) onNewPoseImagesSelected;
  final Function(Pose) onDeletePoseSelected;
  final Function() onDeletePoseGroupSelected;
  final Function() onBackSelected;
  final List<Pose> poseImages;
  final List<Job> activeJobs;
  final Function(Pose, Job) onImageAddedToJobSelected;

  PoseGroupPageState({
    @required this.poseGroup,
    @required this.onNewPoseImagesSelected,
    @required this.onDeletePoseSelected,
    @required this.onDeletePoseGroupSelected,
    @required this.onBackSelected,
    @required this.poseImages,
    @required this.activeJobs,
    @required this.onImageAddedToJobSelected,
  });

  PoseGroupPageState copyWith({
    PoseGroup poseGroup,
    Function(List<XFile>) onNewPoseImagesSelected,
    Function(Pose) onDeletePoseSelected,
    Function() onDeletePoseGroupSelected,
    Function() onBackSelected,
    List<Pose> poseImages,
    List<Job> activeJobs,
    Function(Pose, Job) onImageAddedToJobSelected,
  }){
    return PoseGroupPageState(
      poseGroup: poseGroup ?? this.poseGroup,
      onDeletePoseSelected: onDeletePoseSelected ?? this.onDeletePoseSelected,
      onDeletePoseGroupSelected: onDeletePoseGroupSelected ?? this.onDeletePoseGroupSelected,
      poseImages: poseImages ?? this.poseImages,
      onNewPoseImagesSelected: onNewPoseImagesSelected ?? this.onNewPoseImagesSelected,
      onBackSelected:  onBackSelected ?? this.onBackSelected,
      activeJobs: activeJobs ?? this.activeJobs,
      onImageAddedToJobSelected: onImageAddedToJobSelected ?? this.onImageAddedToJobSelected,
    );
  }

  factory PoseGroupPageState.initial() => PoseGroupPageState(
    poseGroup: null,
    onDeletePoseSelected: null,
    onDeletePoseGroupSelected: null,
    onNewPoseImagesSelected: null,
    onBackSelected: null,
    poseImages: [],
    activeJobs: [],
    onImageAddedToJobSelected: null,
  );

  factory PoseGroupPageState.fromStore(Store<AppState> store) {
    return PoseGroupPageState(
      poseGroup: store.state.poseGroupPageState.poseGroup,
      poseImages: store.state.poseGroupPageState.poseImages,
      activeJobs: store.state.poseGroupPageState.activeJobs,
      onDeletePoseSelected: (pose) => store.dispatch(DeletePoseAction(store.state.poseGroupPageState, pose)),
      onDeletePoseGroupSelected: () => store.dispatch(DeletePoseGroupSelected(store.state.poseGroupPageState)),
      onNewPoseImagesSelected: (poseImages) => {
        store.dispatch(SetLoadingNewImagesState(store.state.poseGroupPageState, true)),
        store.dispatch(SavePosesToGroupAction(store.state.poseGroupPageState, poseImages)),
      },
      onBackSelected: () {
        store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
        },
      onImageAddedToJobSelected: (pose, job) => store.dispatch(SaveSelectedImageToJobFromPosesAction(store.state.poseGroupPageState, pose, job))
    );
  }

  @override
  int get hashCode =>
      poseGroup.hashCode ^
      poseImages.hashCode ^
      onDeletePoseSelected.hashCode ^
      onNewPoseImagesSelected.hashCode ^
      onBackSelected.hashCode ^
      activeJobs.hashCode ^
      onImageAddedToJobSelected.hashCode ^
      onDeletePoseGroupSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PoseGroupPageState &&
              poseImages == other.poseImages &&
              onDeletePoseGroupSelected == onDeletePoseGroupSelected &&
              onDeletePoseSelected == other.onDeletePoseSelected &&
              onBackSelected == other.onBackSelected &&
              onNewPoseImagesSelected == other.onNewPoseImagesSelected &&
              activeJobs == other.activeJobs &&
              onImageAddedToJobSelected == other.onImageAddedToJobSelected &&
              poseGroup == other.poseGroup;
}