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
  final Function(XFile, String, String, List<String>) onNewPoseImagesSelected;
  final String instagramName;


  UploadPosePageState({
    @required this.onNewPoseImagesSelected,
    @required this.instagramName,
  });

  UploadPosePageState copyWith({
    PoseLibraryGroup poseGroup,
    Function(List<XFile>, String, List<String>) onNewPoseImagesSelected,
    String instagramName,
  }){
    return UploadPosePageState(
      onNewPoseImagesSelected: onNewPoseImagesSelected ?? this.onNewPoseImagesSelected,
      instagramName: instagramName ?? this.instagramName,
    );
  }

  factory UploadPosePageState.initial() => UploadPosePageState(
    onNewPoseImagesSelected: null,
    instagramName: '',
  );

  factory UploadPosePageState.fromStore(Store<AppState> store) {
    return UploadPosePageState(
      instagramName: store.state.uploadPosePageState.instagramName,
      onNewPoseImagesSelected: (poseImage, name, url, tags) => {
        store.dispatch(SubmitUploadedPoseAction(store.state.uploadPosePageState, poseImage, name, url, tags)),
      },
    );
  }

  @override
  int get hashCode =>
      onNewPoseImagesSelected.hashCode ^
      instagramName.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadPosePageState &&
              onNewPoseImagesSelected == other.onNewPoseImagesSelected &&
              instagramName == other.instagramName;
}