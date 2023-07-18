import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'UploadPoseActions.dart';

class UploadPosePageState{
  final String instagramName;
  final XFile resizedImage500;
  final XFile resizedImage250;
  final Function(XFile) onPoseUploaded;
  final Function(XFile, XFile, String, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted;

  UploadPosePageState({
    @required this.onPoseSubmitted,
    @required this.instagramName,
    @required this.onPoseUploaded,
    @required this.resizedImage500,
    @required this.resizedImage250,
  });

  UploadPosePageState copyWith({
    String instagramName,
    XFile resizedImage500,
    XFile resizedImage250,
    Function(XFile) onPoseUploaded,
    Function(XFile, XFile, String, String, List<String>, bool, bool, bool, bool, bool, bool, bool, bool, bool) onPoseSubmitted,
  }){
    return UploadPosePageState(
      onPoseSubmitted: onPoseSubmitted ?? this.onPoseSubmitted,
      instagramName: instagramName ?? this.instagramName,
      onPoseUploaded: onPoseUploaded ?? this.onPoseUploaded,
      resizedImage500: resizedImage500 ?? this.resizedImage500,
      resizedImage250: resizedImage250 ?? this.resizedImage250,
    );
  }

  factory UploadPosePageState.initial() => UploadPosePageState(
    onPoseSubmitted: null,
    instagramName: '',
    onPoseUploaded: null,
    resizedImage500: null,
    resizedImage250: null,
  );

  factory UploadPosePageState.fromStore(Store<AppState> store) {
    return UploadPosePageState(
      instagramName: store.state.uploadPosePageState.instagramName,
      resizedImage500: store.state.uploadPosePageState.resizedImage500,
      resizedImage250: store.state.uploadPosePageState.resizedImage250,
      onPoseSubmitted: (poseImage500, poseImage250, name, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
          , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected) => {
        store.dispatch(SubmitUploadedPoseAction(store.state.uploadPosePageState, poseImage500, poseImage250, name, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
            , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected)),
      },
      onPoseUploaded: (xFile) => store.dispatch(ResizeImageAction(store.state.uploadPosePageState, xFile)),
    );
  }

  @override
  int get hashCode =>
      instagramName.hashCode ^
      onPoseSubmitted.hashCode ^
      resizedImage500.hashCode ^
      resizedImage250.hashCode ^
      onPoseSubmitted.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadPosePageState &&
              instagramName == other.instagramName &&
              onPoseUploaded == other.onPoseUploaded &&
              resizedImage500 == other.resizedImage500 &&
              resizedImage250 == other.resizedImage250 &&
              onPoseSubmitted == other.onPoseSubmitted;
}