import 'dart:io';

import 'package:dandylight/AppState.dart';
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
    List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];
    store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));

    for(int index=0; index < groups.length; index++) {
      if(groups.elementAt(index).poses.isNotEmpty){
        imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first));
        next(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));
      } else {
        imageFiles.insert(index, File(''));
      }
    }

    (await PoseGroupDao.getPoseGroupsStream()).listen((groupSnapshots) async {
      List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
      List<File> imageFiles = [];
      store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));

      for(int index=0; index < groups.length; index++) {
        if(groups.elementAt(index).poses.isNotEmpty){
          imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first));
          next(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));
        } else {
          imageFiles.insert(index, File(''));
        }
      }
    });


  }
}