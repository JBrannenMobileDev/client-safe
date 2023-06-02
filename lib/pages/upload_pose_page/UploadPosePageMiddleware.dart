import 'package:dandylight/AppState.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import 'UploadPoseActions.dart';

class UploadPosePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SubmitUploadedPoseAction){
      _createAndSavePoses(store, action);
    }
  }

  void _createAndSavePoses(Store<AppState> store, SubmitUploadedPoseAction action) async {
    Pose newPose = Pose();
    newPose.instagramName = action.name;
    newPose.instagramUrl = action.url;
    newPose.tags = action.tags;
    newPose = await PoseDao.insertOrUpdate(newPose);
    newPose.createDate = DateTime.now();
    // await FileStorage.saveUploadedImage(action.poseImage.path, newPose);//TODO change to submitted photos
  }
}