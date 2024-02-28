import 'package:redux/redux.dart';
import 'SelectAPhotoActions.dart';
import 'SelectAPhotoPageState.dart';



final selectAPhotoReducer = combineReducers<SelectAPhotoPageState>([
  TypedReducer<SelectAPhotoPageState, ClearSelectAPoseStateAction>(_clearState),
  TypedReducer<SelectAPhotoPageState, SetUploadsToState>(_setUploads),
  TypedReducer<SelectAPhotoPageState, AddNewMobileImageToStateAction>(_setNewImage),
  TypedReducer<SelectAPhotoPageState, SetLoadingStateAction>(_setLoadingState),
]);

SelectAPhotoPageState _setLoadingState(SelectAPhotoPageState previousState, SetLoadingStateAction action){
  return previousState.copyWith(
    isLoading: action.isLoading,
  );
}

SelectAPhotoPageState _setNewImage(SelectAPhotoPageState previousState, AddNewMobileImageToStateAction action){
  previousState.uploadImages.add(action.url);
  return previousState.copyWith(
    uploadImages: previousState.uploadImages,
  );
}

SelectAPhotoPageState _setUploads(SelectAPhotoPageState previousState, SetUploadsToState action){
  return previousState.copyWith(
    uploadImages: action.images,
  );
}

SelectAPhotoPageState _clearState(SelectAPhotoPageState previousState, ClearSelectAPoseStateAction action){
  return SelectAPhotoPageState.initial();
}