import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import 'PoseGroupActions.dart';

class PoseGroupPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is DeletePoseAction){
      _deletePoseFromGroup(store, action);
    }
    if(action is DeletePoseGroupSelected){
      _deletePoseGroup(store, action);
    }
    if(action is SharePosesAction){
      _sharePoseImages(store, action);
    }
    if(action is SavePosesToGroupAction){
      _createAndSavePoses(store, action);
    }
    if(action is LoadPoseImagesFromStorage) {
      _loadPoseImages(store, action);
    }
    if(action is DeleteSelectedPoses) {
      _deleteSelectedPoses(store, action);
    }
  }

  void _deleteSelectedPoses(Store<AppState> store, DeleteSelectedPoses action) async{
    List<GroupImage> allImages = action.pageState.poseImages;
    List<Pose> allPoses = action.pageState.poseGroup.poses;
    for(GroupImage selectedImage in action.pageState.selectedImages) {
      allImages.remove(selectedImage);
      allPoses.remove(selectedImage.pose);
    }
    PoseGroup group = action.pageState.poseGroup;
    group.poses = allPoses;
    await PoseGroupDao.update(group);
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, group));
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, allImages));
  }

  void _createAndSavePoses(Store<AppState> store, SavePosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages.length; i++) {
      Pose newPose = await PoseDao.insertOrUpdate(Pose());
      newPoses.add(newPose);
      await FileStorage.savePoseImageFile(action.poseImages.elementAt(i).path, newPose);
    }

    List<GroupImage> groupImages = [];
    for(int index=0 ; index <  newPoses.length; index++){
      groupImages.add(GroupImage(
          file: action.poseImages.elementAt(index),
          pose: newPoses.elementAt(index)
      ));
    }

    PoseGroup poseGroup = action.pageState.poseGroup;
    poseGroup.poses.addAll(newPoses);
    await PoseGroupDao.update(poseGroup);
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, poseGroup));
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, groupImages));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _deletePoseFromGroup(Store<AppState> store, DeletePoseAction action) async{
    List<Pose> resultPoses = action.pageState.poseGroup.poses;
    resultPoses.remove(action.groupImage.pose);
    PoseGroup group = action.pageState.poseGroup;
    group.poses = resultPoses;
    await PoseGroupDao.update(group);
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, group));

    List<GroupImage> groupImages = action.pageState.poseImages;
    groupImages.remove(action.groupImage);
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, groupImages));
  }

  void _deletePoseGroup(Store<AppState> store, DeletePoseGroupSelected action) async{
    await PoseGroupDao.delete(action.pageState.poseGroup.documentId);
    store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
  }

  void _loadPoseImages(Store<AppState> store, LoadPoseImagesFromStorage action) async{
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, await _getGroupImages(action.poseGroup)));
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, action.poseGroup));
  }

  Future<List<GroupImage>> _getGroupImages(PoseGroup poseGroup) async {
    List<GroupImage> poseImages = [];
    for(Pose pose in poseGroup.poses) {
      poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseImageFile(pose)).path), pose: pose));
    }
    return poseImages;
  }

  void _sharePoseImages(Store<AppState> store, SharePosesAction action) async {
    List<String> filePaths = action.pageState.selectedImages.map((groupImage) => groupImage.file.path).toList();
    Share.shareFiles(
          filePaths,
          subject: 'Example Poses');
  }

  pathsDoNotMatch(String path, List<XFile> selectedImages) {
    for(XFile file in selectedImages) {
      if(file.path == path){
        return false;
      }
    }
    return true;
  }
}