

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
  final bool isAdmin;


  PosesPageState({
    @required this.poseGroups,
    @required this.shouldClear,
    @required this.groupImages,
    @required this.libraryGroups,
    @required this.libraryGroupImages,
    @required this.isAdmin,
  });

  PosesPageState copyWith({
    List<PoseGroup> poseGroups,
    List<PoseLibraryGroup> libraryGroups,
    List<File> libraryGroupImages,
    bool shouldClear,
    List<File> groupImages,
    bool isAdmin,
  }){
    return PosesPageState(
      poseGroups: poseGroups?? this.poseGroups,
      shouldClear: shouldClear?? this.shouldClear,
      groupImages: groupImages ?? this.groupImages,
      libraryGroups: libraryGroups ?? this.libraryGroups,
      libraryGroupImages: libraryGroupImages ?? this.libraryGroupImages,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  factory PosesPageState.initial() => PosesPageState(
    poseGroups: [],
    libraryGroups: [],
    groupImages: [],
    libraryGroupImages: [],
    shouldClear: true,
    isAdmin: false,
  );

  factory PosesPageState.fromStore(Store<AppState> store) {
    return PosesPageState(
      poseGroups: store.state.posesPageState.poseGroups,
      groupImages: store.state.posesPageState.groupImages,
      shouldClear: store.state.posesPageState.shouldClear,
      libraryGroups: store.state.posesPageState.libraryGroups,
      libraryGroupImages: store.state.posesPageState.libraryGroupImages,
      isAdmin: store.state.posesPageState.isAdmin,
    );
  }

  @override
  int get hashCode =>
      poseGroups.hashCode ^
      shouldClear.hashCode ^
      groupImages.hashCode ^
      libraryGroups.hashCode ^
      isAdmin.hashCode ^
      libraryGroupImages.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PosesPageState &&
              poseGroups == other.poseGroups &&
              shouldClear == other.shouldClear &&
              groupImages == other.groupImages &&
              libraryGroups == other.libraryGroups &&
              isAdmin == other.isAdmin &&
              libraryGroupImages == other.libraryGroupImages;
}