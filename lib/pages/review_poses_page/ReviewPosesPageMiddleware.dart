import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesActions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
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
    store.dispatch(SetGroupsToStateAction(store.state.reviewPosesPageState, groups));

    List<Pose> poses = [];
    List<GroupImage> groupImages = [];

    groups.forEach((group) {
      group.poses.forEach((pose) {
        if(pose.reviewStatus == Pose.STATUS_SUBMITTED) poses.add(pose);
      });
    });

    poses.sort();

    poses.forEach((pose) async {
      await groupImages.add(GroupImage(file: XFile((await FileStorage.getSubmittedPoseImageFile(pose)).path), pose: pose));
      await store.dispatch(SetPoseImagesToState(store.state.reviewPosesPageState, poses, groupImages));
    });


    store.dispatch(SetPoseImagesToState(store.state.reviewPosesPageState, poses, groupImages));
  }

  void _approvePose(Store<AppState> store, ApprovePoseAction action, NextDispatcher next) async {
    //update submitted pose
    updateSubmittedPoseState(store, Pose.STATUS_FEATURED, action.groupImage, action.pageState.groups);

    //create and save new library pose
    List<PoseLibraryGroup> libraryGroups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
    List<PoseLibraryGroup> libraryGroupsToUpdate = [];
    Pose submittedPose = action.groupImage.pose;
    Pose libraryPose = Pose(
      uid: submittedPose.uid,
      imageUrl: submittedPose.imageUrl,
      instagramUrl: submittedPose.instagramUrl,
      instagramName: submittedPose.instagramName,
      numOfSaves: submittedPose.numOfSaves,
      tags: submittedPose.tags,
      createDate: DateTime.now(),
      categories: submittedPose.categories,
      prompt: submittedPose.prompt,
      reviewStatus: Pose.STATUS_FEATURED,
    );

    libraryPose.categories.forEach((category) {
      PoseLibraryGroup group = getLibraryGroupByCategory(category, libraryGroups);
      if(group != null) {
        group.poses.add(libraryPose);
        libraryGroupsToUpdate.add(group);
      }
    });

    libraryGroupsToUpdate.forEach((group) async {
      await PoseLibraryGroupDao.update(group);
    });
  }

  PoseLibraryGroup getLibraryGroupByCategory(String category, List<PoseLibraryGroup> groups) {
    PoseLibraryGroup result = null;
    groups.forEach((group) {
      if(group.groupName == category) result = group;
    });
    return result;
  }

  void rejectPose(Store<AppState> store, RejectPoseAction action, NextDispatcher next) async {
    updateSubmittedPoseState(store, Pose.STATUS_REVIEWED, action.groupImage, action.pageState.groups);
  }

  void updateSubmittedPoseState(Store<AppState> store, String reviewStatus, GroupImage groupImage, List<PoseSubmittedGroup> groups) async {
    PoseSubmittedGroup groupToUpdate = null;
    groups.forEach((group) {
      group.poses.forEach((pose) {
        if(pose.documentId == groupImage.pose.documentId) {
          pose.reviewStatus = reviewStatus;
          groupImage.pose.reviewStatus = reviewStatus;
          groupToUpdate = group;
        }
      });
    });

    PoseSubmittedGroupDao.update(groupToUpdate);
    store.dispatch(UpdateGroupImageAction(store.state.reviewPosesPageState, groupImage));
  }
}