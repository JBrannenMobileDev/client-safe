import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/pages/pose_group_page/GroupImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../utils/AdminCheckUtil.dart';
import '../poses_page/PosesActions.dart' as posesActions;
import 'LibraryPoseGroupActions.dart';

class LibraryPoseGroupPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveLibraryPosesToGroupAction){
      _createAndSavePoses(store, action);
    }
    if(action is LoadLibraryPoseImagesFromStorage) {
      _loadPoseImages(store, action);
    }
  }

  void _createAndSavePoses(Store<AppState> store, SaveLibraryPosesToGroupAction action) async {
    List<Pose> newPoses = [];
    for(int i=0; i< action.poseImages.length; i++) {
      Pose newPose = await PoseDao.insertOrUpdate(Pose());
      newPoses.add(newPose);
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
  }

  void _loadPoseImages(Store<AppState> store, LoadLibraryPoseImagesFromStorage action) async{
    store.dispatch(SetIsAdminLibraryAction(store.state.libraryPoseGroupPageState, AdminCheckUtil.isAdmin(store.state.dashboardPageState.profile)));
    store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, await _getGroupImages(action.poseGroup)));
    store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, action.poseGroup));
  }

  Future<List<GroupImage>> _getGroupImages(PoseLibraryGroup poseGroup) async {
    List<GroupImage> poseImages = [];
    for(Pose pose in poseGroup.poses) {
      poseImages.add(GroupImage(file: XFile((await FileStorage.getPoseLibraryImageFile(pose, poseGroup)).path), pose: pose));
    }
    return poseImages;
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