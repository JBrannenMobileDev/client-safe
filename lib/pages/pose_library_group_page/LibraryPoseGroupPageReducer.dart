import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupActions.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:redux/redux.dart';

import '../../models/Pose.dart';


final libraryPoseGroupReducer = combineReducers<LibraryPoseGroupPageState>([
  TypedReducer<LibraryPoseGroupPageState, SetLibraryPoseGroupData>(_setPoseGroup),
  TypedReducer<LibraryPoseGroupPageState, ClearLibraryPoseGroupState>(_clearState),
  TypedReducer<LibraryPoseGroupPageState, SetIsAdminLibraryAction>(_setIsAdmin),
  TypedReducer<LibraryPoseGroupPageState, SetActiveJobs>(_setActiveJobs),
  TypedReducer<LibraryPoseGroupPageState, SetPoseGroupsLibraryAction>(_setPoseGroups),
  TypedReducer<LibraryPoseGroupPageState, SetInstagramAction>(_setInstagram),
  TypedReducer<LibraryPoseGroupPageState, SetSortedPosesAction>(_setSortedPoses),
  TypedReducer<LibraryPoseGroupPageState, SetLibraryPoseImagesToState>(_setPoseImages),
  TypedReducer<LibraryPoseGroupPageState, SetLoadingNewLibraryImagesState>(_setLoadingState),
]);

LibraryPoseGroupPageState _setLoadingState(LibraryPoseGroupPageState previousState, SetLoadingNewLibraryImagesState action){
  return previousState.copyWith(
  );
}

LibraryPoseGroupPageState _setPoseImages(LibraryPoseGroupPageState previousState, SetLibraryPoseImagesToState action){
  return previousState.copyWith(
    poseImages: action.poseImages,
  );
}

LibraryPoseGroupPageState _setInstagram(LibraryPoseGroupPageState previousState, SetInstagramAction action){
  return previousState.copyWith(
    instagramName: action.instagramName,
    instagramUrl: action.instagramUrl,
  );
}

LibraryPoseGroupPageState _setPoseGroups(LibraryPoseGroupPageState previousState, SetPoseGroupsLibraryAction action){
  return previousState.copyWith(
    myPoseGroups: action.poseGroups,
  );
}

LibraryPoseGroupPageState _setIsAdmin(LibraryPoseGroupPageState previousState, SetIsAdminLibraryAction action){
  return previousState.copyWith(
    isAdmin: action.isAdmin,
  );
}

LibraryPoseGroupPageState _setActiveJobs(LibraryPoseGroupPageState previousState, SetActiveJobs action){
  return previousState.copyWith(
    activeJobs: action.activeJobs,
  );
}

LibraryPoseGroupPageState _clearState(LibraryPoseGroupPageState previousState, ClearLibraryPoseGroupState action){
  return LibraryPoseGroupPageState.initial();
}

LibraryPoseGroupPageState _setPoseGroup(LibraryPoseGroupPageState previousState, SetLibraryPoseGroupData action){
  return previousState.copyWith(
      poseGroup: action.poseGroup,
  );
}

LibraryPoseGroupPageState _setSortedPoses(LibraryPoseGroupPageState previousState, SetSortedPosesAction action){
  List<Pose> sortedPoses = _sortPoses(action.sortedPoses);
  return previousState.copyWith(
      sortedPoses: sortedPoses
  );
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
