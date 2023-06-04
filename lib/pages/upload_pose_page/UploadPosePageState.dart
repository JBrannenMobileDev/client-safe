import 'dart:io';

import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Pose.dart';
import '../pose_group_page/GroupImage.dart';
import 'UploadPoseActions.dart';

class UploadPosePageState{
  final Function(XFile, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted;

  UploadPosePageState({
    @required this.onPoseSubmitted,
  });

  UploadPosePageState copyWith({
    Function(XFile, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted,
  }){
    return UploadPosePageState(
      onPoseSubmitted: onPoseSubmitted ?? this.onPoseSubmitted,
    );
  }

  factory UploadPosePageState.initial() => UploadPosePageState(
    onPoseSubmitted: null,
  );

  factory UploadPosePageState.fromStore(Store<AppState> store) {
    return UploadPosePageState(
      onPoseSubmitted: (poseImage, name, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
          , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(SubmitUploadedPoseAction(store.state.uploadPosePageState, poseImage, name, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
            , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
    );
  }

  @override
  int get hashCode =>
      onPoseSubmitted.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadPosePageState &&
              onPoseSubmitted == other.onPoseSubmitted;
}