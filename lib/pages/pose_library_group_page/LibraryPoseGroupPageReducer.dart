import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupActions.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:redux/redux.dart';


final libraryPoseGroupReducer = combineReducers<LibraryPoseGroupPageState>([
  TypedReducer<LibraryPoseGroupPageState, SetLibraryPoseGroupData>(_setPoseGroup),
  TypedReducer<LibraryPoseGroupPageState, SetLibraryPoseImagesToState>(_setPoseImages),
  TypedReducer<LibraryPoseGroupPageState, ClearLibraryPoseGroupState>(_clearState),
  TypedReducer<LibraryPoseGroupPageState, SetLoadingNewLibraryImagesState>(_setLoadingState),
  TypedReducer<LibraryPoseGroupPageState, SetIsAdminLibraryAction>(_setIsAdmin),
  TypedReducer<LibraryPoseGroupPageState, SetActiveJobs>(_setActiveJobs),
  TypedReducer<LibraryPoseGroupPageState, SetPoseGroupsLibraryAction>(_setPoseGroups),
  TypedReducer<LibraryPoseGroupPageState, SetInstagramAction>(_setInstagram),
]);

LibraryPoseGroupPageState _setInstagram(LibraryPoseGroupPageState previousState, SetInstagramAction action){
  return previousState.copyWith(
    instagramName: action.instagramName,
    instagramUrl: action.instagramUrl,
  );
}

LibraryPoseGroupPageState _setPoseGroups(LibraryPoseGroupPageState previousState, SetPoseGroupsLibraryAction action){
  return previousState.copyWith(
    myPoseGroups: action.poseGroups,
    myPoseGroupImages: action.imageFiles,
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

LibraryPoseGroupPageState _setLoadingState(LibraryPoseGroupPageState previousState, SetLoadingNewLibraryImagesState action){
  return previousState.copyWith(
    isLoadingNewImages: action.isLoading,
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

LibraryPoseGroupPageState _setPoseImages(LibraryPoseGroupPageState previousState, SetLibraryPoseImagesToState action){
  return previousState.copyWith(
    poseImages: action.poseImages,
    isLoadingNewImages: false,
  );
}
