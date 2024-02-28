import 'dart:io';
import 'package:dandylight/AppState.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/UUID.dart';
import 'package:image/image.dart' as img;

import 'NewQuestionActions.dart';

class NewQuestionPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    // if(action is ResizeQuestionWebImageAction) {
    //   _resizeWebImage(store, action, next);
    // }
    // if(action is ResizeQuestionMobileImageAction) {
    //   _resizeMobileImage(store, action, next);
    // }
  }
}