import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/Profile.dart';
import '../../utils/EnvironmentUtil.dart';
import 'UploadPoseActions.dart';
import 'UploadPosePage.dart';

class UploadPosePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SubmitUploadedPoseAction){
      _createAndSavePoses(store, action);
    }
    if(action is SetInstagramNameAction) {
      _setInstagramName(store, action, next);
    }
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
    ProfileDao.update(profile);

    Pose newPose = Pose();
    newPose.uid = UidUtil().getUid();
    newPose.reviewStatus = Pose.STATUS_SUBMITTED;
    newPose.categories = getCategoryList(action);
    newPose.instagramName = action.name;
    newPose.instagramUrl = "https://www.instagram.com/${action.name.replaceAll('@', '')}/";
    newPose.tags = action.tags;
    newPose = await PoseDao.insertOrUpdate(newPose);
    newPose.createDate = DateTime.now();
    // await FileStorage.saveSubmittedPoseImageFile(action.poseImage.path, newPose, action.pageState.poseGroup);

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

  //Use this code to save unreviewed poses once they are approved.
  // List<GroupImage> groupImages = action.pageState.poseImages;
  // for(int index=0 ; index <  newPoses.length; index++){
  // groupImages.add(GroupImage(
  // file: action.poseImages.elementAt(index),
  // pose: newPoses.elementAt(index)
  // ));
  // }
  //
  // PoseLibraryGroup poseGroup = action.pageState.poseGroup;
  // poseGroup.poses.addAll(newPoses);
  // await PoseLibraryGroupDao.update(poseGroup);
  //
  // await store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, poseGroup));
  // await store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, groupImages));
  // store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState));
  // store.dispatch(SetInstagramAction(store.state.libraryPoseGroupPageState, action.name, action.url));
}