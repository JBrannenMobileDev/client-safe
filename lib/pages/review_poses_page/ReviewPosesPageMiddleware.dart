import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesActions.dart';
import 'package:redux/redux.dart';

import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../models/PoseSubmittedGroup.dart';
import '../upload_pose_page/UploadPosePage.dart';

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
      _loadPosesToReview(store);
    }
  }

  void _loadPosesToReview(Store<AppState> store) async {
    List<PoseSubmittedGroup> groups = await PoseSubmittedGroupDao.getAllSortedMostFrequent();
    store.dispatch(SetGroupsToStateAction(store.state.reviewPosesPageState, groups));

    List<Pose> poses = [];

    await groups.forEach((group) async {
      await group.poses.forEach((pose) async {
        if(pose.reviewStatus == Pose.STATUS_SUBMITTED && pose.imageUrl != null && pose.imageUrl.isNotEmpty) poses.add(pose);
      });
    });

    poses.sort();
    store.dispatch(SetPoseImagesToState(store.state.reviewPosesPageState, poses));
  }

  void _approvePose(Store<AppState> store, ApprovePoseAction action, NextDispatcher next) async {
    //update submitted pose
    updateSubmittedPoseState(store, Pose.STATUS_FEATURED, action.pose, action.pageState.groups);

    //create and save new library pose
    List<PoseLibraryGroup> libraryGroups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
    List<PoseLibraryGroup> libraryGroupsToUpdate = [];
    Pose submittedPose = action.pose;
    Pose libraryPose = Pose(
      uid: submittedPose.uid,
      // documentId: submittedPose.documentId,
      imageUrl: submittedPose.imageUrl,
      instagramUrl: submittedPose.instagramUrl,
      instagramName: submittedPose.instagramName,
      numOfSaves: submittedPose.numOfSaves,
      tags: action.tags.split(','),
      createDate: DateTime.now(),
      categories: getCategoryList(action),
      prompt: action.prompt,
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

  List<String> getCategoryList(ApprovePoseAction action) {
    List<String> categories = [];
    if(action.petsSelected) categories.add(UploadPosePage.PETS);
    if(action.proposalsSelected) categories.add(UploadPosePage.PROPOSALS);
    if(action.newbornSelected) categories.add(UploadPosePage.NEWBORN);
    if(action.weddingsSelected) categories.add(UploadPosePage.WEDDINGS);
    if(action.maternitySelected) categories.add(UploadPosePage.MATERNITY);
    if(action.portraitsSelected) categories.add(UploadPosePage.PORTRAITS);
    if(action.couplesSelected) categories.add(UploadPosePage.COUPLES);
    if(action.familiesSelected) categories.add(UploadPosePage.FAMILIES);
    if(action.engagementsSelected) categories.add(UploadPosePage.ENGAGEMENT);
    return categories;
  }

  PoseLibraryGroup getLibraryGroupByCategory(String category, List<PoseLibraryGroup> groups) {
    PoseLibraryGroup result = null;
    groups.forEach((group) {
      if(group.groupName == category) result = group;
    });
    return result;
  }

  void rejectPose(Store<AppState> store, RejectPoseAction action, NextDispatcher next) async {
    updateSubmittedPoseState(store, Pose.STATUS_REVIEWED, action.pose, action.pageState.groups);
  }

  void updateSubmittedPoseState(Store<AppState> store, String reviewStatus, Pose pose, List<PoseSubmittedGroup> groups) async {
    PoseSubmittedGroup groupToUpdate = null;
    groups.forEach((group) {
      group.poses.forEach((pose) {
        if(pose.documentId == pose.documentId) {
          pose.reviewStatus = reviewStatus;
          pose.reviewStatus = reviewStatus;
          groupToUpdate = group;
        }
      });
    });

    await PoseSubmittedGroupDao.update(groupToUpdate);
    _loadPosesToReview(store);
  }
}