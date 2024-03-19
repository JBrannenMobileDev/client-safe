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
    if(action is SavePosesToGroupAction){
      _createAndSavePoses(store, action);
    }
    if(action is LoadPoseImagesFromStorage) {
      _loadPoseImages(store, action);
    }
    if(action is SaveSelectedImageToJobFromPosesAction) {
      _saveSelectedPoseToJob(store, action);
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, SaveSelectedImageToJobFromPosesAction action) async {
    action.selectedJob!.poses!.add(action.selectedPose!);
    await JobDao.update(action.selectedJob!);
    store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
  }

  void _createAndSavePoses(Store<AppState> store, SavePosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages!.length; i++) {
      Pose newPose = await PoseDao.insertOrUpdate(Pose());
      newPoses.add(newPose);

      final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
      final String uniqueFileName = Uuid().generateV4();
      final cmdLarge = img.Command()
        ..decodeImageFile(action.poseImages!.elementAt(i).path)
        ..copyResize(width: 2160)
        ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg');
      await cmdLarge.execute();

      await FileStorage.savePoseImageFile(
          appDocumentDirectory.path + '/$uniqueFileName' + '500.jpg',
          newPose,
          action.pageState!.poseGroup!
      );
    }

    PoseGroup poseGroup = action.pageState!.poseGroup!;
    poseGroup.poses!.addAll(newPoses);
    await PoseGroupDao.update(poseGroup);

    EventSender().sendEvent(eventName: EventNames.CREATED_POSES, properties: {
      EventNames.POSES_PARAM_GROUP_NAME : poseGroup.groupName!,
      EventNames.POSES_PARAM_IMAGE_COUNT : newPoses.length,
    });


    await store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, poseGroup));
    await store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, poseGroup.poses));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState!));
  }

  void _deletePoseFromGroup(Store<AppState> store, DeletePoseAction action) async{
    List<Pose>? resultPoses = action.pageState!.poseGroup!.poses!;
    resultPoses.remove(action.pose);
    PoseGroup group = action.pageState!.poseGroup!;
    action.pageState!.poseGroup!.poses = resultPoses;
    await PoseGroupDao.update(group);
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, group));

    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, resultPoses));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState!));
  }

  void _deletePoseGroup(Store<AppState> store, DeletePoseGroupSelected action) async{
    await PoseGroupDao.delete(action.pageState!.poseGroup!.documentId!);
    PoseGroup? groupToCheck = await PoseGroupDao.getById(action.pageState!.poseGroup!.documentId!);
    if(groupToCheck != null) {
      await PoseGroupDao.delete(action.pageState!.poseGroup!.documentId!);
    }

    store.dispatch(ClearPoseGroupState(store.state.poseGroupPageState));
    store.dispatch(FetchPoseGroupsAction(store.state.posesPageState!));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }

  void _loadPoseImages(Store<AppState> store, LoadPoseImagesFromStorage action) async{
    store.dispatch(SetPoseGroupData(store.state.poseGroupPageState, action.poseGroup));
    store.dispatch(SetPoseImagesToState(store.state.poseGroupPageState, action.poseGroup!.poses));
    store.dispatch(SetActiveJobsToPoses(store.state.poseGroupPageState, JobUtil.getActiveJobs((await JobDao.getAllJobs()))));
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