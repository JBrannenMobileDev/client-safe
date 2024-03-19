import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/models/PoseSubmittedGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synchronized/synchronized.dart';

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
    if(action is FetchMyPoseGroupsAction) {
      _fetchMyPoseGroups(store, next);
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveImageToJobAction action) async {
    Pose pose = action.selectedPose!;
    pose.numOfSaves = pose.numOfSaves! + 1;
    action.selectedJob!.poses!.add(pose);
    await PoseDao.update(pose);
    await JobDao.update(action.selectedJob!);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SavePoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup!;
    groupToUpdate.poses!.add(action.selectedImage!);
    action.selectedImage!.numOfSaves = action.selectedImage!.numOfSaves! + 1;
    await PoseDao.update(action.selectedImage!);
    await PoseGroupDao.update(groupToUpdate);
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }

  void fetchPoseGroups(Store<AppState> store, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetIsAdminAction(store.state.posesPageState, AdminCheckUtil.isAdmin(profile)));
    _fetchMyPoseGroups(store, next);
    _fetchLibraryPoseGroups(store, next);
    loadAllSubmittedImages(store);
    store.dispatch(SetActiveJobsToPosesPage(store.state.posesPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
    store.dispatch(SetPosesProfileAction(store.state.posesPageState, profile));
  }

  void _fetchLibraryPoseGroups(Store<AppState> store, NextDispatcher next) async {
    List<PoseLibraryGroup> groups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
    store.dispatch(SetPoseLibraryGroupsAction(store.state.posesPageState, groups));

    List<Pose> allPoses = [];
    for(PoseLibraryGroup group in groups) {
      allPoses.addAll(group.poses!);
    }

    store.dispatch(SetAllPosesAction(store.state.posesPageState, allPoses));
  }

  void loadAllSubmittedImages(Store<AppState> store) async {
    (await PoseSubmittedGroupDao.getStream(UidUtil().getUid())).listen((invoiceSnapshots) async {
      PoseSubmittedGroup? submittedGroup;
      for(RecordSnapshot invoiceSnapshot in invoiceSnapshots) {
        submittedGroup = (PoseSubmittedGroup.fromMap(invoiceSnapshot.value! as Map<String,dynamic>));
      }
      if(submittedGroup != null) {
        processPoses(store, submittedGroup);
      }
    });
  }

  void processPoses(Store<AppState> store, PoseSubmittedGroup submittedPosesGroup) async {
    List<Pose> submittedPoses = submittedPosesGroup.poses!;
    submittedPoses.sort();
    store.dispatch(SetSortedSubmittedPosesAction(store.state.posesPageState, submittedPosesGroup.poses));
  }

  void _fetchMyPoseGroups(Store<AppState> store, NextDispatcher next) async {
    List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
    store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups));
  }
}

