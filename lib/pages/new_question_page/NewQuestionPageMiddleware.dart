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
    if(action is ResizeQuestionWebImageAction) {
      _resizeWebImage(store, action, next);
    }
    if(action is ResizeQuestionMobileImageAction) {
      _resizeMobileImage(store, action, next);
    }
  }

  void _resizeWebImage(Store<AppState> store, ResizeQuestionWebImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 1920)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    store.dispatch(SetResizedQuestionWebImageAction(store.state.newQuestionPageState, resizedImage)); //TODO set XFiles to state so that we can show them in grid.


    //TODO when user selects iamge from grid, then get the downloadUrl and set it to newQuestion state/object
    await FileStorage.saveQuestionWebImageFile(resizedImage.path, questionnaire, question.id, (taskSnapshot) => () => {});
  }

  void _resizeMobileImage(Store<AppState> store, ResizeQuestionMobileImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 1080)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'question.jpg');
    store.dispatch(SetResizedQuestionMobileImageAction(store.state.newQuestionPageState, resizedImage));
    await FileStorage.saveQuestionMobileImageFile(resizedImage.path, questionnaire, question.id, (taskSnapshot) => () => {});
  }
}