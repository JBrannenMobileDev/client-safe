import 'SelectAPhotoPageState.dart';

class ClearSelectAPoseStateAction {
  final SelectAPhotoPageState pageState;
  ClearSelectAPoseStateAction(this.pageState);
}

class SetUploadsToState {
  final SelectAPhotoPageState pageState;
  final List<String> urls;
  SetUploadsToState(this.pageState, this.urls);
}

class LoadUploadedPhotosAction {
  final SelectAPhotoPageState pageState;
  LoadUploadedPhotosAction(this.pageState);
}