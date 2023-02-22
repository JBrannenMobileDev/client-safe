import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/JobDao.dart';
import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../utils/AdminCheckUtil.dart';
import '../../utils/JobUtil.dart';
import '../job_details_page/JobDetailsActions.dart';

class PosesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchPoseGroupsAction){
      fetchPoseGroups(store, next);
    }
    if(action is SavePoseToMyPosesAction) {
      _saveSelectedPoseToMyPoseGroup(store, action);
    }
    if(action is SaveImageToJobAction) {
      _saveSelectedPoseToJob(store, action);
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveImageToJobAction action) async {
    Pose pose = action.selectedPose;
    pose.numOfSaves++;
    action.selectedJob.poses.add(pose);
    await PoseDao.update(pose);
    await JobDao.update(action.selectedJob);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SavePoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup;
    groupToUpdate.poses.add(action.selectedImage.pose);
    action.selectedImage.pose.numOfSaves++;
    await PoseDao.update(action.selectedImage.pose);
    await PoseGroupDao.update(groupToUpdate);
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }

  void fetchPoseGroups(Store<AppState> store, NextDispatcher next) async{
    store.dispatch(SetIsAdminAction(store.state.posesPageState, AdminCheckUtil.isAdmin(store.state.dashboardPageState.profile)));
    _fetchMyPoseGroups(store, next);
    _fetchLibraryPoseGroups(store, next);
    _fetchAllLibraryPoses(store, next);
    store.dispatch(SetActiveJobsToPosesPage(store.state.posesPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
  }
}

void _fetchLibraryPoseGroups(Store<AppState> store, NextDispatcher next) async {
  await PoseLibraryGroupDao.syncAllFromFireStore();
  List<PoseLibraryGroup> groups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
  List<File> imageFiles = [];
  store.dispatch(SetPoseLibraryGroupsAction(store.state.posesPageState, groups, imageFiles));

  for(int index=0; index < groups.length; index++) {
    if(groups.elementAt(index).poses.isNotEmpty && groups.elementAt(index).poses.first.imageUrl?.isNotEmpty == true){
      imageFiles.insert(index, await FileStorage.getPoseLibraryImageFile(groups.elementAt(index).poses.first, groups.elementAt(index)));
      next(SetPoseLibraryGroupsAction(store.state.posesPageState, groups, imageFiles));
    } else {
      imageFiles.insert(index, File(''));
    }
  }
}

void _fetchAllLibraryPoses(Store<AppState> store, NextDispatcher next) async {
  List<Pose> libraryPoses = (await PoseDao.getAllSortedMostFrequent()).where((pose) => pose.isLibraryPose()).toList();
  List<File> imageFiles = [];

  for(int index=0; index < libraryPoses.length; index++) {
    if(libraryPoses.elementAt(index).imageUrl?.isNotEmpty == true){
      imageFiles.insert(index, await FileStorage.getPoseLibraryImageFile(libraryPoses.elementAt(index), null));
      store.dispatch(SetAllPosesAction(store.state.posesPageState, libraryPoses, imageFiles));
    } else {
      imageFiles.insert(index, File(''));
    }
  }
}

void _fetchMyPoseGroups(Store<AppState> store, NextDispatcher next) async {
  List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
  List<File> imageFiles = [];
  store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));

  for(int index=0; index < groups.length; index++) {
    List<Pose> poses = groups.elementAt(index).poses;
    if(poses.isNotEmpty) {
      poses.sort();
    }
    if(poses.isNotEmpty && poses.first.imageUrl?.isNotEmpty == true){
      if(poses.first.isLibraryPose()) {
        imageFiles.insert(index, await FileStorage.getPoseImageFile(poses.first, groups.elementAt(index), true, null));
      } else {
        imageFiles.insert(index, await FileStorage.getPoseImageFile(poses.first, groups.elementAt(index), false, null));
      }
      next(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));
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
        if(groups.elementAt(index).poses.first.isLibraryPose()) {
          imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first, groups.elementAt(index), true, null));
        } else {
          imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first, groups.elementAt(index), false, null));
        }
        if(index == streamGroups.length-1) {
          next(SetPoseGroupsAction(store.state.posesPageState, streamGroups, imageFiles));
        }
      } else {
        imageFiles.insert(index, File(''));
      }
    }
  });
}