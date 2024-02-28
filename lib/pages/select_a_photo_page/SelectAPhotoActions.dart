import 'package:image_picker/image_picker.dart';

import 'SelectAPhotoPageState.dart';

class ClearSelectAPoseStateAction {
  final SelectAPhotoPageState pageState;
  ClearSelectAPoseStateAction(this.pageState);
}

class SetUploadsToState {
  final SelectAPhotoPageState pageState;
  final List<String> images;
  SetUploadsToState(this.pageState, this.images);
}

class LoadUploadedPhotosAction {
  final SelectAPhotoPageState pageState;
  LoadUploadedPhotosAction(this.pageState);
}

class ResizeAndSaveUploadedImageAction {
  final SelectAPhotoPageState pageState;
  final XFile webImage;
  final XFile mobileImage;
  ResizeAndSaveUploadedImageAction(this.pageState, this.webImage, this.mobileImage);
}

class AddNewMobileImageToStateAction {
  final SelectAPhotoPageState pageState;
  final String url;
  AddNewMobileImageToStateAction(this.pageState, this.url);
}

class SetLoadingStateAction {
  final SelectAPhotoPageState pageState;
  final bool isLoading;
  SetLoadingStateAction(this.pageState, this.isLoading);
}