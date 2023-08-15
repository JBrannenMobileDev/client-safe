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
import 'package:synchronized/synchronized.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../models/Profile.dart';
import '../../utils/AdminCheckUtil.dart';
import '../../utils/JobUtil.dart';
import '../../utils/UidUtil.dart';
import '../job_details_page/JobDetailsActions.dart';
import '../poses_page/PosesActions.dart' as posesActions;
import 'LibraryPoseGroupActions.dart';

class LibraryPoseGroupPageMiddleware extends MiddlewareClass<AppState> {


  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadLibraryPoseGroup) {
      _loadPoseImages(store, action);
    }
    if(action is SortGroupImages) {
      _sortGroupImages(store, action, next);
    }
    if(action is SaveSelectedPoseToMyPosesAction) {
      _saveSelectedPoseToMyPoseGroup(store, action);
    }
    if(action is SaveSelectedImageToJobAction) {
      _saveSelectedPoseToJob(store, action);
    }
    if(action is FetchMyPoseGroupsForLibraryAction) {
      _fetchMyPoseGroups(store);
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveSelectedImageToJobAction action) async {
    Pose pose = action.selectedPose;
    pose.numOfSaves++;
    store.state.libraryPoseGroupPageState.poseGroup.numOfSaves++;
    action.selectedJob.poses.add(pose);
    PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState.poseGroup);
    JobDao.update(action.selectedJob);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SaveSelectedPoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup;
    action.selectedImage.numOfSaves++;
    groupToUpdate.poses.add(action.selectedImage);
    store.state.libraryPoseGroupPageState.poseGroup.numOfSaves++;
    await PoseDao.update(action.selectedImage);
    await PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState.poseGroup);
    await PoseGroupDao.update(groupToUpdate);
    store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _sortGroupImages(Store<AppState> store, SortGroupImages action, NextDispatcher next) async{
    await store.dispatch(SetSortedPosesAction(action.pageState, action.poseGroup.poses));
  }

  void _loadPoseImages(Store<AppState> store, LoadLibraryPoseGroup action) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetIsAdminLibraryAction(store.state.libraryPoseGroupPageState, AdminCheckUtil.isAdmin(profile)));
    store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, action.poseGroup));
    store.dispatch(SetActiveJobs(store.state.libraryPoseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
    _fetchMyPoseGroups(store);
  }

  void _fetchMyPoseGroups(Store<AppState> store) async {
    (await PoseGroupDao.getPoseGroupsStream()).listen((snapshots) async {
      List<PoseGroup> streamGroups = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamGroups.add(PoseGroup.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetPoseGroupsLibraryAction(store.state.libraryPoseGroupPageState, streamGroups));
    });
  }
}