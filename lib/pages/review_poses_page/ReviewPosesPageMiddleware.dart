import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesActions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseSubmittedGroup.dart';
import '../pose_group_page/GroupImage.dart';

class ReviewPosesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is ApprovePoseAction){
      _approvePose(store, action, next);
    }
    if(action is RejectPoseAction) {
      rejectPose(store, action, next);
    }
    if(action is LoadPosesToReviewAction) {
      _loadPosesToReview(store, action, next);
    }
  }

  void _loadPosesToReview(Store<AppState> store, LoadPosesToReviewAction action, NextDispatcher next) async {
    List<PoseSubmittedGroup> groups = await PoseSubmittedGroupDao.getAllSortedMostFrequent();
    List<Pose> poses = [];
    List<GroupImage> groupImages = [];

    groups.forEach((group) {
      group.poses.forEach((pose) {
        if(pose.reviewStatus == Pose.STATUS_SUBMITTED) poses.add(pose);
      });
    });

    await poses.forEach((pose) async {
      await groupImages.insert(0, GroupImage(file: XFile((await FileStorage.getSubmittedPoseImageFile(pose)).path), pose: pose));
      store.dispatch(SetPoseImagesToState(store.state.reviewPosesPageState, poses, groupImages));
    });

    store.dispatch(SetPoseImagesToState(store.state.reviewPosesPageState, poses, groupImages));
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