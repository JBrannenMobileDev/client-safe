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
    if(action is SaveLibraryPosesToGroupAction){
      _createAndSavePoses(store, action);
    }
    if(action is LoadLibraryPoseGroup) {
      _loadPoseImages(store, action);
    }
    if(action is LoadMoreImagesAction) {
      _loadMoreImages(store, action, next);
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
    await PoseDao.update(pose);
    await PoseLibraryGroupDao.update(store.state.libraryPoseGroupPageState.poseGroup);
    await JobDao.update(action.selectedJob);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _saveSelectedPoseToMyPoseGroup(Store<AppState> store, SaveSelectedPoseToMyPosesAction action) async {
    PoseGroup groupToUpdate = action.selectedGroup;
    action.selectedImage.pose.numOfSaves++;
    groupToUpdate.poses.add(action.selectedImage.pose);
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
      newPose.tags = action.tags;
      newPose = await PoseDao.insertOrUpdate(newPose);
      newPoses.add(newPose);
      newPose.createDate = DateTime.now();
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
    store.dispatch(SetInstagramAction(store.state.libraryPoseGroupPageState, action.name, action.url));
  }

  void _loadMoreImages(Store<AppState> store, LoadMoreImagesAction action, NextDispatcher next) async{
    var lock = Lock();
    lock.synchronized(() async {
      List<GroupImage> poseImages = action.pageState.poseImages;
      List<Pose> sortedPoses = _sortPoses(action.poseGroup.poses);
      final int PAGE_SIZE = 10;

      int posesSize = poseImages.length;

      final List<Future<dynamic>> featureList = <Future<dynamic>>[];
      for(int startIndex = posesSize; startIndex < posesSize + PAGE_SIZE; startIndex++) {
        await featureList.add(_fetchImage(sortedPoses, startIndex, action, poseImages));
      }
      await Future.wait<dynamic>(featureList);

      store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, poseImages));
      store.dispatch(SetLoadingNewLibraryImagesState(store.state.libraryPoseGroupPageState, false));
    });
  }

  Future _fetchImage(List<Pose> sortedPoses, int startIndex, LoadMoreImagesAction action, List<GroupImage> poseImages) async {
    if(sortedPoses.length > startIndex) {
      Pose pose = sortedPoses.elementAt(startIndex);
      poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseLibraryImageFile(pose, action.poseGroup)).path), pose: pose));
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

    oldPoses.sort((a, b) => b.numOfSaves.compareTo(a.numOfSaves) == 0 ? b.createDate.compareTo(a.createDate) : b.numOfSaves.compareTo(a.numOfSaves));
    newPoses.sort((a, b) => b.numOfSaves.compareTo(a.numOfSaves) == 0 ? b.createDate.compareTo(a.createDate) : b.numOfSaves.compareTo(a.numOfSaves));
    return newPoses + oldPoses;
  }

  void _loadPoseImages(Store<AppState> store, LoadLibraryPoseGroup action) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetIsAdminLibraryAction(store.state.libraryPoseGroupPageState, AdminCheckUtil.isAdmin(profile)));
    store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, action.poseGroup));
    store.dispatch(SetActiveJobs(store.state.libraryPoseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
    _fetchMyPoseGroups(store);
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
        imageFiles.insert(index, await FileStorage.getPoseImageFile(groups.elementAt(index).poses.first, groups.elementAt(index), false, null));
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
          imageFiles.insert(index, await FileStorage.getPoseImageFile(streamGroups.elementAt(index).poses.first, streamGroups.elementAt(index), false, null));
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