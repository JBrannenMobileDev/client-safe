

import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class PosesPageState{

  final List<PoseGroup> poseGroups;
  final List<File> groupImages;
  final bool shouldClear;
  final Function(PoseGroup) onGroupSelected;


  PosesPageState({
    @required this.poseGroups,
    @required this.shouldClear,
    @required this.onGroupSelected,
    @required this.groupImages,
  });

  PosesPageState copyWith({
    List<PoseGroup> poseGroups,
    bool shouldClear,
    Function(PoseGroup) onGroupSelected,
    List<File> groupImages,
  }){
    return PosesPageState(
      poseGroups: poseGroups?? this.poseGroups,
      shouldClear: shouldClear?? this.shouldClear,
      onGroupSelected: onGroupSelected?? this.onGroupSelected,
      groupImages: groupImages ?? this.groupImages,
    );
  }

  factory PosesPageState.initial() => PosesPageState(
    poseGroups: [],
    groupImages: [],
    shouldClear: true,
    onGroupSelected: null,
  );

  factory PosesPageState.fromStore(Store<AppState> store) {
    return PosesPageState(
      poseGroups: store.state.posesPageState.poseGroups,
      groupImages: store.state.posesPageState.groupImages,
      shouldClear: store.state.posesPageState.shouldClear,
      onGroupSelected: (group) => null,
      // onGroupSelected: (group) => store.dispatch(LoadExistingPoseGroup(store.state.posesPageState, group)),
    );
  }

  @override
  int get hashCode =>
      poseGroups.hashCode ^
      shouldClear.hashCode ^
      groupImages.hashCode ^
      onGroupSelected.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PosesPageState &&
              poseGroups == other.poseGroups &&
              shouldClear == other.shouldClear &&
              groupImages == other.groupImages &&
              onGroupSelected == other.onGroupSelected;
}