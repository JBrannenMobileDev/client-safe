import 'package:redux/redux.dart';
import 'SelectAPhotoActions.dart';
import 'SelectAPhotoPageState.dart';



final selectAPhotoReducer = combineReducers<SelectAPhotoPageState>([
  TypedReducer<SelectAPhotoPageState, ClearSelectAPoseStateAction>(_clearState),
  TypedReducer<SelectAPhotoPageState, SetUploadsToState>(_setUploads),
]);

SelectAPhotoPageState _setUploads(SelectAPhotoPageState previousState, SetUploadsToState action){
  return previousState.copyWith(
    urls: action.urls,
  );
}

SelectAPhotoPageState _clearState(SelectAPhotoPageState previousState, ClearSelectAPoseStateAction action){
  return SelectAPhotoPageState.initial();
}