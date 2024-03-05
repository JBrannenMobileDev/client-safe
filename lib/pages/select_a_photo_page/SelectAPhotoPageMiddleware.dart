import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/select_a_photo_page/SelectAPhotoActions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:image/image.dart' as img;

import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/UUID.dart';
import '../../utils/UidUtil.dart';

class SelectAPhotoPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadUploadedPhotosAction) {
      _loadPosesToReview(store);
    }
    if(action is ResizeAndSaveUploadedImageAction) {
      _resizeAndSave(store, action, next);
    }
  }

  void _resizeAndSave(Store<AppState> store, ResizeAndSaveUploadedImageAction action, NextDispatcher next) {
    _resizeWebImage(store, action, next);
    _resizeMobileImage(store, action, next);
  }

  void _resizeWebImage(Store<AppState> store, ResizeAndSaveUploadedImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.webImage.path)
      ..copyResize(width: 1920)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    await FileStorage.saveQuestionWebImageFile(resizedImage.path, (url) {}, (taskSnapshot) => () => {});
  }

  void _resizeMobileImage(Store<AppState> store, ResizeAndSaveUploadedImageAction action, NextDispatcher next) async {
    store.dispatch(SetLoadingStateAction(store.state.selectAPhotoPageState, true));
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.mobileImage.path)
      ..copyResize(width: 1080)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    save(url) {
      store.dispatch(SetLoadingStateAction(store.state.selectAPhotoPageState, false));
      store.dispatch(AddNewMobileImageToStateAction(store.state.selectAPhotoPageState, url));
    }
    await FileStorage.saveQuestionMobileImageFile(
        resizedImage.path,
        save,
        (taskSnapshot) => () => {});
  }

  void saveImageUrl(String url, Store<AppState> store) {
    store.dispatch(AddNewMobileImageToStateAction(store.state.selectAPhotoPageState, url));
  }

  void _loadPosesToReview(Store<AppState> store) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ListResult result = await (storageRef.child("env/prod/images/${UidUtil().getUid()}/questions").listAll());

    List<String> mobileImages = [];
    for (var item in result.items) {
      String url = await item.getDownloadURL();
      if(url.contains('MobileImage')) {
        mobileImages.add(url);
      }
    }
    store.dispatch(SetLoadingStateAction(store.state.selectAPhotoPageState, false));
    store.dispatch(SetUploadsToState(store.state.selectAPhotoPageState, mobileImages));
  }
}