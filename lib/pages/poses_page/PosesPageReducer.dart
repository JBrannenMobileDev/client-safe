import 'dart:io';

import 'package:dandylight/models/Pose.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../pose_group_page/GroupImage.dart';

final posesReducer = combineReducers<PosesPageState>([
  TypedReducer<PosesPageState, SetPoseGroupsAction>(_setPoseGroups),
  TypedReducer<PosesPageState, SetPoseLibraryGroupsAction>(_setPoseLibraryGroups),
  TypedReducer<PosesPageState, SetIsAdminAction>(_setIsAdmin),
  TypedReducer<PosesPageState, UpdateSearchInputAction>(_setSearchInput),
  TypedReducer<PosesPageState, SetActiveJobsToPosesPage>(_setActiveJobs),
  TypedReducer<PosesPageState, SetAllPosesAction>(_setAllPoses),
]);

PosesPageState _setAllPoses(PosesPageState previousState, SetAllPosesAction action){
  return previousState.copyWith(
    allLibraryPoses: action.allPoses,
    allLibraryPoseImages: action.allImages,
  );
}

PosesPageState _setActiveJobs(PosesPageState previousState, SetActiveJobsToPosesPage action){
  return previousState.copyWith(
    activeJobs: action.activeJobs,
  );
}

PosesPageState _setSearchInput(PosesPageState previousState, UpdateSearchInputAction action){
  List<String> searchWords = action.searchInput.split(' ').map((word) => word.toLowerCase()).toList();
  List<GroupImage> searchResultsImages = [];
  List<Pose> allPoses = action.pageState.allLibraryPoses;
  List<File> allImages = action.pageState.allLibraryPoseImages;

  for(String word in searchWords) {
    for(int index = 0; index < allPoses.length; index++) {
      for(String tag in allPoses.elementAt(index).tags) {
        if(tag.toLowerCase().contains(word)) {
          searchResultsImages.add(GroupImage(file: XFile(allImages.elementAt(index).path), pose: allPoses.elementAt(index)));
        }
      }
    }
  }

  // remove duplicates

  return previousState.copyWith(
    searchInput: action.searchInput,
    searchResultsImages: searchResultsImages,
  );
}

PosesPageState _setIsAdmin(PosesPageState previousState, SetIsAdminAction action){
  return previousState.copyWith(
    isAdmin: action.isAdmin,
  );
}

PosesPageState _setPoseGroups(PosesPageState previousState, SetPoseGroupsAction action){
  return previousState.copyWith(
      poseGroups: action.poseGroups,
      groupImages: action.imageFiles,
  );
}

PosesPageState _setPoseLibraryGroups(PosesPageState previousState, SetPoseLibraryGroupsAction action){
  return previousState.copyWith(
    libraryGroups: action.poseGroups,
    libraryGroupImages: action.imageFiles,
  );
}

