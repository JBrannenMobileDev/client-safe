import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesActions.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import '../../models/PoseLibraryGroup.dart';
import '../pose_group_page/GroupImage.dart';
import '../pose_library_group_page/LibraryPoseGroupActions.dart';

class UploadPosePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is ApprovePoseAction){
      _approvePose(store, action, next);
    }
    if(action is RejectPoseAction) {
      rejectPose(store, action, next);
    }
  }
  void _approvePose(Store<AppState> store, ApprovePoseAction action, NextDispatcher next) async {
    // List<GroupImage> groupImages = action.pageState.poseImages;
    // for(int index=0 ; index <  newPoses.length; index++){
    //   groupImages.add(GroupImage(
    //       file: action.poseImages.elementAt(index),
    //       pose: newPoses.elementAt(index)
    //   ));
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

  void rejectPose(Store<AppState> store, RejectPoseAction action, NextDispatcher next) async {

  }
}