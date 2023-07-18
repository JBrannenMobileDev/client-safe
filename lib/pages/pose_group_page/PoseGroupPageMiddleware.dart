import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../data_layer/local_db/daos/JobDao.dart';
import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/local_db/daos/PoseGroupDao.dart';
import '../../data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseGroup.dart';
import '../../utils/GlobalKeyUtil.dart';
import '../../utils/JobUtil.dart';
import '../../utils/UUID.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'PoseGroupActions.dart';
import 'package:image/image.dart' as img;

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
    if(action is SaveSelectedImageToJobFromPosesAction) {
      _saveSelectedPoseToJob(store, action);
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveSelectedImageToJobFromPosesAction action) async {
    action.selectedJob.poses.add(action.selectedPose);
    await JobDao.update(action.selectedJob);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _deleteSelectedPoses(Store<AppState> store, DeleteSelectedPoses action) async{
    List<GroupImage> allImages = List.from(action.pageState.poseImages);
    List<Pose> allPoses = List.from(action.pageState.poseGroup.poses);
    for(GroupImage selectedImage in action.pageState.selectedImages) {
      allImages.remove(selectedImage);
      allPoses.remove(selectedImage.pose);
    }
    PoseGroup group = action.pageState.poseGroup;
    group.poses = allPoses;//delete selected image list
    await PoseGroupDao.update(group);
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, group));
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, allImages));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _createAndSavePoses(Store<AppState> store, SavePosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages.length; i++) {
      Pose newPose = await PoseDao.insertOrUpdate(Pose());
      newPoses.add(newPose);

      final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
      final String uniqueFileName = Uuid().generateV4();
      final cmdLarge = img.Command()
        ..decodeImageFile(action.poseImages.elementAt(i).path)
        ..copyResize(width: 1080)
        ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg');
      await cmdLarge.execute();
      final cmdSmall = img.Command()
        ..decodeImageFile(action.poseImages.elementAt(i).path)
        ..copyResize(width: 350)
        ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + '250.jpg');
      await cmdSmall.execute();

      await FileStorage.savePoseImageFile(
          appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg',
          appDocumentDirectory.path + '/$uniqueFileName' + '250.jpg',
          newPose,
          action.pageState.poseGroup
      );
    }

    List<GroupImage> groupImages = action.pageState.poseImages;
    for(int index=0 ; index <  newPoses.length; index++){
      groupImages.add(GroupImage(
          file: action.poseImages.elementAt(index),
          pose: newPoses.elementAt(index)
      ));
    }

    PoseGroup poseGroup = action.pageState.poseGroup;
    poseGroup.poses.addAll(newPoses);
    await PoseGroupDao.update(poseGroup);

    EventSender().sendEvent(eventName: EventNames.CREATED_POSES, properties: {
      EventNames.POSES_PARAM_GROUP_NAME : poseGroup.groupName,
      EventNames.POSES_PARAM_IMAGE_COUNT : newPoses.length,
    });


    await store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, poseGroup));
    await store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, groupImages));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
    // await FileStorage.updatePosesImageUrl(poseGroup, newPoses);
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
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
  }

  void _deletePoseGroup(Store<AppState> store, DeletePoseGroupSelected action) async{
    await PoseGroupDao.delete(action.pageState.poseGroup.documentId);
    PoseGroup groupToCheck = await PoseGroupDao.getById(action.pageState.poseGroup.documentId);
    if(groupToCheck != null) {
      await PoseGroupDao.delete(action.pageState.poseGroup.documentId);
    }

    store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _loadPoseImages(Store<AppState> store, LoadPoseImagesFromStorage action) async{
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, action.poseGroup));
    await _getGroupImages(store, action.poseGroup);
    store.dispatch(SetActiveJobsToPoses(store.state.poseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
  }

  void _getGroupImages(Store<AppState> store, PoseGroup poseGroup) async {
    List<GroupImage> poseImages = [];
    for(Pose pose in poseGroup.poses) {
      if(pose.isLibraryPose()) {
        await poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseImageFile(pose, poseGroup, true, null)).path), pose: pose));
      } else {
        await poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseImageFile(pose, poseGroup, false, null)).path), pose: pose));
      }
      store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, poseImages));
    }
  }

  Future fetchImage(Pose pose, List<GroupImage> poseImages, PoseGroup poseGroup, Store<AppState> store) async {

  }

  void _sharePoseImages(Store<AppState> store, SharePosesAction action) async {
    List<String> filePaths = action.pageState.selectedImages.map((groupImage) => groupImage.file.path).toList();
    Share.shareFiles(
          filePaths,
          subject: 'Example Poses');
    EventSender().sendEvent(eventName: EventNames.BT_SHARE_POSES);
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