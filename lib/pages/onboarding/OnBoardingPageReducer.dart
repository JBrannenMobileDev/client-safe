import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'OnBoardingActions.dart';

final onBoardingReducer = combineReducers<OnBoardingPageState>([
  TypedReducer<OnBoardingPageState, SetFeatureSelectedStateAction>(_setSelectedFeature),
  TypedReducer<OnBoardingPageState, SetPagerIndexAction>(_setPagerIndex),
  TypedReducer<OnBoardingPageState, SetHasJobAnswerAction>(_setHasJobAnswer),
  TypedReducer<OnBoardingPageState, SetSelectedJobCountAction>(_setJobCount),
  TypedReducer<OnBoardingPageState, SetSelectedZoomOptionAction>(_setZoomOption),
]);

OnBoardingPageState _setZoomOption(OnBoardingPageState previousState, SetSelectedZoomOptionAction action){
  return previousState.copyWith(
    selectedZoomOption: action.zoomOption,
  );
}

OnBoardingPageState _setJobCount(OnBoardingPageState previousState, SetSelectedJobCountAction action){
  return previousState.copyWith(
    selectedJobCount: action.jobCount,
  );
}

OnBoardingPageState _setHasJobAnswer(OnBoardingPageState previousState, SetHasJobAnswerAction action){
  return previousState.copyWith(
    selectedOptionHasJob: action.answer,
  );
}

OnBoardingPageState _setPagerIndex(OnBoardingPageState previousState, SetPagerIndexAction action){
  if(previousState.pagerIndex == 1 && action.index == 2) {
    for(String reason in action.pageState.selectedReasons) {
      EventSender().sendEvent(eventName: EventNames.ON_BOARDING_PROBLEM_CHOSEN, properties: {
        EventNames.ON_BOARDING_PROBLEM_CHOSEN_PARAM : reason,
      });
    }
  }
  return previousState.copyWith(
      pagerIndex: action.index,
  );
}

OnBoardingPageState _setSelectedFeature(OnBoardingPageState previousState, SetFeatureSelectedStateAction action){
  if(action.isSelected) {
    previousState.selectedReasons.add(action.featureName);
  } else {
    previousState.selectedReasons.remove(action.featureName);
  }

  return previousState.copyWith(
    selectedReasons: previousState.selectedReasons,
    featuresContinueEnabled: previousState.selectedReasons.isNotEmpty,
  );
}
