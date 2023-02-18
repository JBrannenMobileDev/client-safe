

import 'dart:io';

import 'package:dandylight/models/PoseGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/PoseLibraryGroup.dart';

class PosesPageState{

  final List<PoseGroup> poseGroups;
  final List<PoseLibraryGroup> libraryGroups;
  final List<File> groupImages;
  final List<File> libraryGroupImages;
  final bool shouldClear;


  PosesPageState({
    @required this.poseGroups,
    @required this.shouldClear,
    @required this.groupImages,
    @required this.libraryGroups,
    @required this.libraryGroupImages,
  });

  PosesPageState copyWith({
    List<PoseGroup> poseGroups,
    List<PoseLibraryGroup> libraryGroups,
    List<File> libraryGroupImages,
    bool shouldClear,
    List<File> groupImages,
  }){
    return PosesPageState(
      poseGroups: poseGroups?? this.poseGroups,
      shouldClear: shouldClear?? this.shouldClear,
      groupImages: groupImages ?? this.groupImages,
      libraryGroups: libraryGroups ?? this.libraryGroups,
      libraryGroupImages: libraryGroupImages ?? this.libraryGroupImages,
    );
  }

  factory PosesPageState.initial() => PosesPageState(
    poseGroups: [],
    libraryGroups: [],
    groupImages: [],
    libraryGroupImages: [],
    shouldClear: true,
  );

  factory PosesPageState.fromStore(Store<AppState> store) {
    return PosesPageState(
      poseGroups: store.state.posesPageState.poseGroups,
      groupImages: store.state.posesPageState.groupImages,
      shouldClear: store.state.posesPageState.shouldClear,
      libraryGroups: store.state.posesPageState.libraryGroups,
      libraryGroupImages: store.state.posesPageState.libraryGroupImages,
    );
  }

  @override
  int get hashCode =>
      poseGroups.hashCode ^
      shouldClear.hashCode ^
      groupImages.hashCode ^
      libraryGroups.hashCode ^
      libraryGroupImages.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PosesPageState &&
              poseGroups == other.poseGroups &&
              shouldClear == other.shouldClear &&
              groupImages == other.groupImages &&
              libraryGroups == other.libraryGroups &&
              libraryGroupImages == other.libraryGroupImages;
}