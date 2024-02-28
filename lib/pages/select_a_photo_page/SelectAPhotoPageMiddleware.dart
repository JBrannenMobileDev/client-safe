import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/select_a_photo_page/SelectAPhotoActions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:redux/redux.dart';

import '../../utils/UidUtil.dart';

class SelectAPhotoPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadUploadedPhotosAction) {
      _loadPosesToReview(store);
    }
  }

  void _loadPosesToReview(Store<AppState> store) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ListResult result = await (storageRef.child("env/prod/images/${UidUtil().getUid()}/questions").listAll());

    List<String> webImages = [];
    List<String> mobileImages = [];
    for (var item in result.items) {
      String url = await item.getDownloadURL();
      if(url.contains('WebImage')) {
        webImages.add(url);
      }
      if(url.contains('MobileImage')) {
        mobileImages.add(url);
      }
    }
    store.dispatch(SetUploadsToState(store.state.selectAPhotoPageState, webImages));
  }
}