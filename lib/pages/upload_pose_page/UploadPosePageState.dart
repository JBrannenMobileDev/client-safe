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
  final String instagramName;
  final Function(XFile, String, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted;

  UploadPosePageState({
    @required this.onPoseSubmitted,
    @required this.instagramName
  });

  UploadPosePageState copyWith({
    String instagramName,
    Function(XFile, String, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted,
  }){
    return UploadPosePageState(
      onPoseSubmitted: onPoseSubmitted ?? this.onPoseSubmitted,
      instagramName: instagramName ?? this.instagramName,
    );
  }

  factory UploadPosePageState.initial() => UploadPosePageState(
    onPoseSubmitted: null,
    instagramName: '',
  );

  factory UploadPosePageState.fromStore(Store<AppState> store) {
    return UploadPosePageState(
      instagramName: store.state.uploadPosePageState.instagramName,
      onPoseSubmitted: (poseImage, name, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
          , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(SubmitUploadedPoseAction(store.state.uploadPosePageState, poseImage, name, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
            , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
    );
  }

  @override
  int get hashCode =>
      instagramName.hashCode ^
      onPoseSubmitted.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadPosePageState &&
              instagramName == other.instagramName &&
              onPoseSubmitted == other.onPoseSubmitted;
}