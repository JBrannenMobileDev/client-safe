import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:share_plus/share_plus.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../utils/AdminCheckUtil.dart';
import '../../utils/JobUtil.dart';
import '../poses_page/PosesActions.dart' as posesActions;
import 'LibraryPoseGroupActions.dart';

class LibraryPoseGroupPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveLibraryPosesToGroupAction){
      _createAndSavePoses(store, action);
    }
    if(action is LoadLibraryPoseImagesFromStorage) {
      _loadPoseImages(store, action);
    }
    if(action is SaveSelectedPoseToMyPosesAction) {
      _saveSelectedPoseToMyPoseGroup(store, action);
    }
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SaveSelectedPoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup;
    groupToUpdate.poses.add(action.selectedImage.pose);
    action.selectedImage.pose.numOfSaves++;
    store.state.libraryPoseGroupPageState.poseGroup.numOfSaves++;
    await PoseDao.update(action.selectedImage.pose);
    await PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState.poseGroup);
    await PoseGroupDao.update(groupToUpdate);
    store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _createAndSavePoses(Store<AppState> store, SaveLibraryPosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages.length; i++) {
      Pose newPose = Pose();
      newPose.instagramName = action.name;
      newPose.instagramUrl = action.url;
      newPose = await PoseDao.insertOrUpdate(newPose);
      newPoses.add(newPose);
      await FileStorage.saveLibraryPoseImageFile(action.poseImages.elementAt(i).path, newPose, action.pageState.poseGroup);
    }

    List<GroupImage> groupImages = action.pageState.poseImages;
    for(int index=0 ; index <  newPoses.length; index++){
      groupImages.add(GroupImage(
          file: action.poseImages.elementAt(index),
          pose: newPoses.elementAt(index)
      ));
    }

    PoseLibraryGroup poseGroup = action.pageState.poseGroup;
    poseGroup.poses.addAll(newPoses);
    await PoseLibraryGroupDao.update(poseGroup);

    await store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, poseGroup));
    await store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, groupImages));
    store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _loadPoseImages(Store<AppState> store, LoadLibraryPoseImagesFromStorage action) async{
    store.dispatch(SetIsAdminLibraryAction(store.state.libraryPoseGroupPageState, AdminCheckUtil.isAdmin(store.state.dashboardPageState.profile)));
    store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, await _getGroupImages(action.poseGroup)));
    store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, action.poseGroup));
    store.dispatch(SetActiveJobs(store.state.libraryPoseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
    _fetchMyPoseGroups(store);
  }

  Future<List<GroupImage>> _getGroupImages(PoseLibraryGroup poseGroup) async {
    List<GroupImage> poseImages = [];
    List<Pose> sortedPoses = poseGroup.poses;
    sortedPoses.sort();
    for(Pose pose in sortedPoses) {
      poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseLibraryImageFile(pose, poseGroup)).path), pose: pose));
    }
    return poseImages;
  }

  pathsDoNotMatch(String path, List<XFile> selectedImages) {
    for(XFile file in selectedImages) {
      if(file.path == path){
        return false;
      }
    }
    return true;
  }

  void _fetchMyPoseGroups(Store<AppState> store) async {
    List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];
    store.dispatch(SetPoseGroupsLibraryAction(store.state.libraryPoseGroupPageState, groups, imageFiles));

    for(int index=0; index < groups.length; index++) {
      if(groups.elementAt(index).poses.isNotEmpty && groups.elementAt(index).poses.first.imageUrl?.isNotEmpty == true){
        imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first, groups.elementAt(index), false));
        store.dispatch(SetPoseGroupsLibraryAction(store.state.libraryPoseGroupPageState, groups, imageFiles));
      } else {
        imageFiles.insert(index, File(''));
      }
    }

    (await PoseGroupDao.getPoseGroupsStream()).listen((snapshots) async {
      List<PoseGroup> streamGroups = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamGroups.add(PoseGroup.fromMap(clientSnapshot.value));
      }

      List<File> imageFiles = [];

      for(int index=0; index < streamGroups.length; index++) {
        if(streamGroups.elementAt(index).poses.isNotEmpty && streamGroups.elementAt(index).poses.first.imageUrl?.isNotEmpty == true){
          imageFiles.insert(index, await FileStorage.getPoseImageFile(streamGroups.elementAt(index).poses.first, streamGroups.elementAt(index), false));
          if(index == streamGroups.length-1) {
            store.dispatch(SetPoseGroupsLibraryAction(store.state.libraryPoseGroupPageState, streamGroups, imageFiles));
          }
        } else {
          imageFiles.insert(index, File(''));
        }
      }
    });
  }
}