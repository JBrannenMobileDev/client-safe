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
  TypedReducer<PosesPageState, ClearPoseSearchPageAction>(_clearState),
  TypedReducer<PosesPageState, SetSortedSubmittedPosesAction>(_setSortedSubmittedPoses),
  TypedReducer<PosesPageState, SetPosesProfileAction>(_setProfile),
  TypedReducer<PosesPageState, ClearPosesPageStateAction>(_clearPageState),
]);

PosesPageState _clearPageState(PosesPageState previousState, ClearPosesPageStateAction action){
  return PosesPageState.initial();
}

PosesPageState _setProfile(PosesPageState previousState, SetPosesProfileAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

PosesPageState _setSortedSubmittedPoses(PosesPageState previousState, SetSortedSubmittedPosesAction action){
  return previousState.copyWith(
    sortedSubmittedPoses: action.submittedPoses,
  );
}

PosesPageState _clearState(PosesPageState previousState, ClearPoseSearchPageAction action){
  return PosesPageState.initial();
}

PosesPageState _setAllPoses(PosesPageState previousState, SetAllPosesAction action){
  return previousState.copyWith(
    allLibraryPoses: action.allPoses,
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

  for(int index = 0; index < allPoses.length; index++) {
    //compare by tags
    if(poseMatchesAllSearchWords(searchWords, allPoses.elementAt(index))) {
      if (!poseDuplicateReference.contains(allPoses.elementAt(index))) {
        searchResultsPoses.add(allPoses.elementAt(index));
        poseDuplicateReference.add(allPoses.elementAt(index));
      }
    }
  }

  return previousState.copyWith(
    searchInput: action.searchInput,
    searchResultPoses: action.searchInput.isNotEmpty ? searchResultsPoses : [],
  );
}

bool poseMatchesAllSearchWords(List<String> searchWords, Pose pose) {
  int matchingWords = 0;
  int expectedMatchingWords = searchWords.length;

  searchWords.forEach((searchWord) {
    pose.tags.forEach((tag) {
      if(tag.toLowerCase() == searchWord.toLowerCase()) {
        matchingWords++;
      }
    });
  });
  return matchingWords == expectedMatchingWords;
}

PosesPageState _setIsAdmin(PosesPageState previousState, SetIsAdminAction action){
  return previousState.copyWith(
    isAdmin: action.isAdmin,
  );
}

PosesPageState _setPoseGroups(PosesPageState previousState, SetPoseGroupsAction action){
  return previousState.copyWith(
      poseGroups: action.poseGroups,
  );
}

PosesPageState _setPoseLibraryGroups(PosesPageState previousState, SetPoseLibraryGroupsAction action){
  return previousState.copyWith(
    libraryGroups: action.poseGroups,
  );
}

