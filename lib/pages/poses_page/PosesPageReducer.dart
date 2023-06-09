import 'package:dandylight/models/Pose.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:redux/redux.dart';

final posesReducer = combineReducers<PosesPageState>([
  TypedReducer<PosesPageState, SetPoseGroupsAction>(_setPoseGroups),
  TypedReducer<PosesPageState, SetPoseLibraryGroupsAction>(_setPoseLibraryGroups),
  TypedReducer<PosesPageState, SetIsAdminAction>(_setIsAdmin),
  TypedReducer<PosesPageState, UpdateSearchInputAction>(_setSearchInput),
  TypedReducer<PosesPageState, SetActiveJobsToPosesPage>(_setActiveJobs),
  TypedReducer<PosesPageState, SetAllPosesAction>(_setAllPoses),
  TypedReducer<PosesPageState, SetSearchResultPosesAction>(_setSearchResultPoses),
  TypedReducer<PosesPageState, SetSubmittedPosesAction>(_setSubmittedPoses),
  TypedReducer<PosesPageState, ClearPoseSearchPageAction>(_clearState),
  TypedReducer<PosesPageState, SetLoadingNewSearchResultImagesState>(_setLoadingState),
  TypedReducer<PosesPageState, SetLoadingSubmittedPosesState>(_setLoadingSubmittedPosesState),
  TypedReducer<PosesPageState, SetSortedSubmittedPosesAction>(_setSortedSubmittedPoses),
]);

PosesPageState _setSortedSubmittedPoses(PosesPageState previousState, SetSortedSubmittedPosesAction action){
  return previousState.copyWith(
    sortedSubmittedPoses: action.submittedPoses,
  );
}

PosesPageState _setLoadingSubmittedPosesState(PosesPageState previousState, SetLoadingSubmittedPosesState action){
  return previousState.copyWith(
    isLoadingSubmittedPoses: action.isLoading,
  );
}

PosesPageState _setLoadingState(PosesPageState previousState, SetLoadingNewSearchResultImagesState action){
  return previousState.copyWith(
    isLoadingSearchImages: action.isLoadingSearchImages,
  );
}

PosesPageState _clearState(PosesPageState previousState, ClearPoseSearchPageAction action){
  return PosesPageState.initial();
}

PosesPageState _setSearchResultPoses(PosesPageState previousState, SetSearchResultPosesAction action){
  return previousState.copyWith(
    searchResultsImages: action.searchResultImages,
  );
}

PosesPageState _setSubmittedPoses(PosesPageState previousState, SetSubmittedPosesAction action){
  return previousState.copyWith(
    submittedPoses: action.submittedPoses,
  );
}

PosesPageState _setAllPoses(PosesPageState previousState, SetAllPosesAction action){
  return previousState.copyWith(
    allLibraryPoses: action.allPoses,
    searchResultsImages: action.allImages,
  );
}

PosesPageState _setActiveJobs(PosesPageState previousState, SetActiveJobsToPosesPage action){
  return previousState.copyWith(
    activeJobs: action.activeJobs,
  );
}

PosesPageState _setSearchInput(PosesPageState previousState, UpdateSearchInputAction action){
  List<String> searchWords = action.searchInput.split(' ').map((word) => word.toLowerCase()).toList();
  List<Pose> searchResultsPoses = [];
  List<Pose> allPoses = action.pageState.allLibraryPoses;
  List<Pose> poseDuplicateReference = [];

  for(String word in searchWords) {
    if(word.length > 2) {
      for(int index = 0; index < allPoses.length; index++) {
        //compare by tags
        for(String tag in allPoses.elementAt(index).tags) {
          if(tag.toLowerCase().contains(word)) {
            if(!poseDuplicateReference.contains(allPoses.elementAt(index))) {
              searchResultsPoses.add(allPoses.elementAt(index));
              poseDuplicateReference.add(allPoses.elementAt(index));
            }
          }
        }

        //Compare by Instagram Name
        if(allPoses.elementAt(index).instagramName.toLowerCase().contains(word)) {
          if(!poseDuplicateReference.contains(allPoses.elementAt(index))) {
            searchResultsPoses.add(allPoses.elementAt(index));
            poseDuplicateReference.add(allPoses.elementAt(index));
          }
        }

        //Compare by Instagram Url
        if(allPoses.elementAt(index).instagramUrl.toLowerCase().contains(word)) {
          if(!poseDuplicateReference.contains(allPoses.elementAt(index))) {
            searchResultsPoses.add(allPoses.elementAt(index));
            poseDuplicateReference.add(allPoses.elementAt(index));
          }
        }
      }
    }
  }

  return previousState.copyWith(
    searchInput: action.searchInput,
    searchResultPoses: action.searchInput.isNotEmpty ? searchResultsPoses : [],
    searchResultsImages: [],
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

