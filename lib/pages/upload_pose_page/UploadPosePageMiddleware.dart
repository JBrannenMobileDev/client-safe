import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/utils/UUID.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/Profile.dart';
import 'UploadPoseActions.dart';
import 'UploadPosePage.dart';
import 'package:image/image.dart' as img;

class UploadPosePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SubmitUploadedPoseAction){
      _createAndSavePoses(store, action);
    }
    if(action is SetInstagramNameAction) {
      _setInstagramName(store, action, next);
    }
    if(action is ResizeImageAction) {
      _resizeImage(store, action, next);
    }
  }

  void _resizeImage(Store<AppState> store, ResizeImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 2040)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg');
    await cmdLarge.execute();
    XFile resizedImage500 = XFile(appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg');
    store.dispatch(SetResizedImageAction(store.state.uploadPosePageState, resizedImage500));
  }

  void _setInstagramName(Store<AppState> store, SetInstagramNameAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile.instagramName.isNotEmpty) {
      next(SetInstagramNameAction(store.state.uploadPosePageState, profile.instagramName));
    }
  }

  void _createAndSavePoses(Store<AppState> store, SubmitUploadedPoseAction action) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.instagramName = action.name;
    await ProfileDao.update(profile);

    Pose newPose = Pose();
    newPose.uid = UidUtil().getUid();
    newPose.reviewStatus = Pose.STATUS_SUBMITTED;
    newPose.categories = getCategoryList(action);
    newPose.instagramName = action.name;
    newPose.instagramUrl = "https://www.instagram.com/${action.name.replaceAll('@', '')}/";
    newPose.tags = action.tags;
    newPose.prompt = action.prompt;
    newPose = await PoseDao.insertOrUpdate(newPose);
    newPose.createDate = DateTime.now();
    await FileStorage.saveSubmittedPoseImageFile(action.poseImage500.path, newPose);
    await PoseSubmittedGroupDao.addNewSubmission(newPose);
  }

  List<String> getCategoryList(SubmitUploadedPoseAction action) {
    List<String> categories = [];
    if(action.petsSelected) categories.add(UploadPosePage.PETS);
    if(action.proposalsSelected) categories.add(UploadPosePage.PROPOSALS);
    if(action.newbornSelected) categories.add(UploadPosePage.NEWBORN);
    if(action.weddingsSelected) categories.add(UploadPosePage.WEDDINGS);
    if(action.maternitySelected) categories.add(UploadPosePage.MATERNITY);
    if(action.portraitsSelected) categories.add(UploadPosePage.PORTRAITS);
    if(action.couplesSelected) categories.add(UploadPosePage.COUPLES);
    if(action.familiesSelected) categories.add(UploadPosePage.FAMILIES);
    if(action.engagementsSelected) categories.add(UploadPosePage.ENGAGEMENT);
    return categories;
  }
}