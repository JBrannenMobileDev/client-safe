import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'SelectAPhotoActions.dart';

class SelectAPhotoPageState{
  final List<String> uploadImages;
  final bool isLoading;
  final Function(XFile, XFile) onImageUploaded;

  SelectAPhotoPageState({
    @required this.uploadImages,
    @required this.onImageUploaded,
    @required this.isLoading,
  });

  SelectAPhotoPageState copyWith({
    List<String> uploadImages,
    bool isLoading,
    Function(XFile, XFile) onImageUploaded,
  }){
    return SelectAPhotoPageState(
      uploadImages: uploadImages ?? this.uploadImages,
      onImageUploaded: onImageUploaded ?? this.onImageUploaded,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory SelectAPhotoPageState.initial() => SelectAPhotoPageState(
    uploadImages: [],
    onImageUploaded: null,
    isLoading: true,
  );

  factory SelectAPhotoPageState.fromStore(Store<AppState> store) {
    return SelectAPhotoPageState(
      uploadImages: store.state.selectAPhotoPageState.uploadImages,
      isLoading: store.state.selectAPhotoPageState.isLoading,
      onImageUploaded: (webImage, mobileImage) => store.dispatch(ResizeAndSaveUploadedImageAction(store.state.selectAPhotoPageState, webImage, mobileImage)),
    );
  }

  @override
  int get hashCode =>
      onImageUploaded.hashCode ^
      isLoading.hashCode ^
      uploadImages.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectAPhotoPageState &&
              onImageUploaded == other.onImageUploaded &&
              isLoading == other.isLoading &&
              uploadImages == other.uploadImages;
}