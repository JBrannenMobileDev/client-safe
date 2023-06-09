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
import '../pose_group_page/GroupImage.dart';

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
    if(action is LoadMorePoseImagesAction) {
      loadMoreImages(store, next);
    }
    if(action is LoadMoreSubmittedImagesAction) {
      loadMoreSubmittedImages(store, next, action);
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
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetIsAdminAction(store.state.posesPageState, AdminCheckUtil.isAdmin(profile)));
    _fetchMyPoseGroups(store, next);
    _fetchLibraryPoseGroups(store, next);
    store.dispatch(SetActiveJobsToPosesPage(store.state.posesPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
  }

  void _fetchLibraryPoseGroups(Store<AppState> store, NextDispatcher next) async {
    List<PoseLibraryGroup> groups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];
    store.dispatch(SetPoseLibraryGroupsAction(store.state.posesPageState, groups, imageFiles));

    for(int index=0; index < groups.length; index++) {
      Pose poseForGroupImage = null;
      groups.elementAt(index).poses.forEach((pose) {
        if(poseForGroupImage == null) poseForGroupImage = pose;
        if(pose.numOfSaves > poseForGroupImage.numOfSaves) poseForGroupImage = pose;
      });
      if(groups.elementAt(index).poses.isNotEmpty && poseForGroupImage.imageUrl?.isNotEmpty == true){
        imageFiles.insert(index, await FileStorage.getPoseLibraryImageFile(poseForGroupImage, groups.elementAt(index)));
        next(SetPoseLibraryGroupsAction(store.state.posesPageState, groups, imageFiles));
      } else {
        imageFiles.insert(index, File(''));
      }
    }

    List<Pose> allPoses = [];
    for(PoseLibraryGroup group in groups) {
      allPoses.addAll(group.poses);
    }

    store.dispatch(SetAllPosesAction(store.state.posesPageState, allPoses, []));
  }

  void loadMoreImages(Store<AppState> store, NextDispatcher next) async {
    var lock = Lock();
    lock.synchronized(() async {
      if(!store.state.posesPageState.isLoadingSearchImages) {
        store.dispatch(SetLoadingNewSearchResultImagesState(store.state.posesPageState, true));
        List<Pose> libraryPoses = store.state.posesPageState.searchResultPoses;

        List<GroupImage> imageFiles = store.state.posesPageState.searchResultsImages;
        libraryPoses = _sortPoses(libraryPoses);

        final int PAGE_SIZE = 10;

        int posesSize = imageFiles.length;

        final List<Future<dynamic>> featureList = <Future<dynamic>>[];
        for(int startIndex = posesSize; startIndex < posesSize + PAGE_SIZE; startIndex++) {
          featureList.add(_fetchImage(libraryPoses, startIndex, imageFiles, store));
        }
        await Future.wait<dynamic>(featureList);

        store.dispatch(SetLoadingNewSearchResultImagesState(store.state.posesPageState, false));
      }
    });
  }

  void loadMoreSubmittedImages(Store<AppState> store, NextDispatcher next, LoadMoreSubmittedImagesAction action) async {
    PoseSubmittedGroup submittedPosesGroup = await PoseSubmittedGroupDao.getByUid(UidUtil().getUid());

    (await PoseSubmittedGroupDao.getStream()).listen((invoiceSnapshots) async {
      List<PoseSubmittedGroup> submittedGroup = [];
      for(RecordSnapshot invoiceSnapshot in invoiceSnapshots) {
        submittedGroup.add(PoseSubmittedGroup.fromMap(invoiceSnapshot.value));
      }
      processPoses(store, next, action, submittedPosesGroup);
    });
  }

  void processPoses(Store<AppState> store, NextDispatcher next, LoadMoreSubmittedImagesAction action, PoseSubmittedGroup submittedPosesGroup) async {
    List<Pose> submittedPoses = submittedPosesGroup.poses;
    store.dispatch(SetSortedSubmittedPosesAction(store.state.posesPageState, submittedPosesGroup.poses));

    var lock = Lock();
    lock.synchronized(() async {
      if(!store.state.posesPageState.isLoadingSubmittedPoses) {
        store.dispatch(SetLoadingSubmittedPosesState(store.state.posesPageState, true));

        List<GroupImage> imageFiles = store.state.posesPageState.submittedPoses;

        final int PAGE_SIZE = 10;

        int posesSize = imageFiles.length;

        final List<Future<dynamic>> featureList = <Future<dynamic>>[];
        for(int startIndex = posesSize; startIndex < posesSize + PAGE_SIZE; startIndex++) {
          featureList.add(_fetchSubmittedImage(submittedPoses, startIndex, imageFiles, store));
        }
        await Future.wait<dynamic>(featureList);

        store.dispatch(SetLoadingSubmittedPosesState(store.state.posesPageState, false));
      }
    });
  }

  Future _fetchImage(List<Pose> libraryPoses, int startIndex, List<GroupImage> imageFiles, Store<AppState> store) async {
    if(libraryPoses.length > startIndex) {
      Pose pose = libraryPoses.elementAt(startIndex);
      imageFiles.add(GroupImage(file: XFile((await FileStorage.getPoseLibraryImageFile(pose, null)).path), pose: pose));
      store.dispatch(SetSearchResultPosesAction(store.state.posesPageState, imageFiles));
    }
  }

  List<Pose> _sortPoses(List<Pose> poses) {
    List<Pose> newPoses = [];
    List<Pose> oldPoses = [];

    for(Pose pose in poses) {
      if(pose.isNewPose()){
        newPoses.add(pose);
      } else {
        oldPoses.add(pose);
      }
    }

    return newPoses + oldPoses;
  }

  Future _fetchSubmittedImage(List<Pose> submittedPoses, int startIndex, List<GroupImage> imageFiles, Store<AppState> store) async {
    if(submittedPoses.length > startIndex) {
      Pose pose = submittedPoses.elementAt(startIndex);
      imageFiles.add(GroupImage(file: XFile((await FileStorage.getSubmittedPoseImageFile(pose)).path), pose: pose));
      store.dispatch(SetSubmittedPosesAction(store.state.posesPageState, imageFiles));
    }
  }

  void _fetchMyPoseGroups(Store<AppState> store, NextDispatcher next) async {
    List<PoseGroup> groups = await PoseGroupDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];
    store.dispatch(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));

    for(int index=0; index < groups.length; index++) {
      List<Pose> poses = groups.elementAt(index).poses;
      if(poses.isNotEmpty && poses.first.imageUrl?.isNotEmpty == true){
        if(poses.first.isLibraryPose()) {
          imageFiles.insert(index, await FileStorage.getPoseImageFile(poses.first, groups.elementAt(index), true, null));
        } else {
          imageFiles.insert(index, await FileStorage.getPoseImageFile(poses.first, groups.elementAt(index), false, null));
        }
      } else {
        imageFiles.insert(index, File(''));
      }
      next(SetPoseGroupsAction(store.state.posesPageState, groups, imageFiles));
    }
  }
}

