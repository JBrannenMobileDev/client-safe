import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/PoseGroup.dart';

class PosesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchPoseGroupsAction){
      fetchPoseGroups(store, next);
    }
  }

  void fetchPoseGroups(Store<AppState> store, NextDispatcher next) async{
    _fetchMyPoseGroups(store, next);
    _fetchLibraryPoseGroups(store, next);
  }
}

void _fetchLibraryPoseGroups(Store<AppState> store, NextDispatcher next) async {
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

void _fetchMyPoseGroups(Store<AppState> store, NextDispatcher next) async {
  List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
  List<File> imageFiles = [];
  store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));

  for(int index=0; index < groups.length; index++) {
    if(groups.elementAt(index).poses.isNotEmpty && groups.elementAt(index).poses.first.imageUrl?.isNotEmpty == true){
      imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first, groups.elementAt(index)));
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
        imageFiles.insert(index, await FileStorage.getPoseImageFile(streamGroups.elementAt(index).poses.first, streamGroups.elementAt(index)));
        if(index == streamGroups.length-1) {
          next(SetPoseGroupsAction(store.state.posesPageState, streamGroups, imageFiles));
        }
      } else {
        imageFiles.insert(index, File(''));
      }
    }
  });
}