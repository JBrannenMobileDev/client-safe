import 'package:dandylight/AppState.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/PoseDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import 'UploadPoseActions.dart';

class UploadPosePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SubmitUploadedPoseAction){
      _createAndSavePoses(store, action);
    }
  }

  void _createAndSavePoses(Store<AppState> store, SubmitUploadedPoseAction action) async {
    String name = action.name.replaceAll('@', '');
    Pose newPose = Pose(); //TODO change to SubmittedPose matching firebase
    newPose.instagramName = action.name;
    newPose.instagramUrl = "https://www.instagram.com/$name/";
    newPose.tags = action.tags;
    newPose = await PoseDao.insertOrUpdate(newPose);
    newPose.createDate = DateTime.now();
    await FileStorage.saveLibraryPoseImageFile(action.poseImage.path, newPose, action.pageState.poseGroup);
  }

  //Use this code to save unreviewed poses once they are approved.
  // List<GroupImage> groupImages = action.pageState.poseImages;
  // for(int index=0 ; index <  newPoses.length; index++){
  // groupImages.add(GroupImage(
  // file: action.poseImages.elementAt(index),
  // pose: newPoses.elementAt(index)
  // ));
  // }
  //
  // PoseLibraryGroup poseGroup = action.pageState.poseGroup;
  // poseGroup.poses.addAll(newPoses);
  // await PoseLibraryGroupDao.update(poseGroup);
  //
  // await store.dispatch(SetLibraryPoseGroupData(store.state.libraryPoseGroupPageState, poseGroup));
  // await store.dispatch(SetLibraryPoseImagesToState(store.state.libraryPoseGroupPageState, groupImages));
  // store.dispatch(posesActions.FetchPoseGroupsAction(store.state.posesPageState));
  // store.dispatch(SetInstagramAction(store.state.libraryPoseGroupPageState, action.name, action.url));
}