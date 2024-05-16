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
import '../dashboard_page/DashboardPageActions.dart';
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
    if(action is SaveLibraryPosesToGroupAction){
      _createAndSavePoses(store, action);
    }
  }

  void _createAndSavePoses(Store<AppState> store, SaveLibraryPosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages!.length; i++) {
      Pose newPose = Pose();
      newPose.instagramName = action.name;
      newPose.instagramUrl = action.url;
      newPose.tags = action.tags;
      newPose = await PoseDao.insertOrUpdate(newPose);
      newPoses.add(newPose);
      newPose.createDate = DateTime.now();
      await FileStorage.saveLibraryPoseImageFile(action.poseImages!.elementAt(i).path, newPose, action.pageState!.poseGroup!);
    }

    List<GroupImage> groupImages = action.pageState!.poseImages!;
    for(int index=0 ; index <  newPoses.length; index++){
      groupImages.add(GroupImage(
          file: action.poseImages!.elementAt(index),
          pose: newPoses.elementAt(index)
      ));
    }

    PoseLibraryGroup poseGroup = action.pageState!.poseGroup!;
    poseGroup.poses!.addAll(newPoses);
    await PoseLibraryGroupDao.update(poseGroup);

    await store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, poseGroup));
    await store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, groupImages));
    store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState!));
    store.dispatch(SetInstagramAction(store.state.libraryPoseGroupPageState, action.name, action.url));
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveSelectedImageToJobAction action) async {
    Pose pose = action.selectedPose!;
    pose.numOfSaves = pose.numOfSaves! + 1;
    store.state.libraryPoseGroupPageState!.poseGroup!.numOfSaves = store.state.libraryPoseGroupPageState!.poseGroup!.numOfSaves! + 1;
    action.selectedJob!.poses!.add(pose);
    PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState!.poseGroup!);
    JobDao.update(action.selectedJob!);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.addPosesToJob) {
      profile.progress.addPosesToJob = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    }
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SaveSelectedPoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup!;
    action.selectedImage!.numOfSaves = action.selectedImage!.numOfSaves! + 1;
    groupToUpdate.poses!.add(action.selectedImage!);
    store.state.libraryPoseGroupPageState!.poseGroup!.numOfSaves = store.state.libraryPoseGroupPageState!.poseGroup!.numOfSaves! + 1;
    await PoseDao.update(action.selectedImage!);
    await PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState!.poseGroup!);
    await PoseGroupDao.update(groupToUpdate);
    store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState!));
  }

  void _sortGroupImages(Store<AppState> store, SortGroupImages action, NextDispatcher next) async{
    await store.dispatch(SetSortedPosesAction(action.pageState, action.poseGroup!.poses!));
  }

  void _loadPoseImages(Store<AppState> store, LoadLibraryPoseGroup action) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetIsAdminLibraryAction(store.state.libraryPoseGroupPageState, AdminCheckUtil.isAdmin(profile)));
    store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, action.poseGroup));
    store.dispatch(SetActiveJobs(store.state.libraryPoseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs())!)));
    _fetchMyPoseGroups(store);
  }

  void _fetchMyPoseGroups(Store<AppState> store) async {
    (await PoseGroupDao.getPoseGroupsStream()).listen((snapshots) async {
      List<PoseGroup> streamGroups = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamGroups.add(PoseGroup.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetPoseGroupsLibraryAction(store.state.libraryPoseGroupPageState, streamGroups));
    });
  }
}