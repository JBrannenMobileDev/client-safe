import 'package:dandylight/pages/onboarding_flow_pages/OnBoardingFlowPageActions.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnboardingFlowPageState.dart';
import 'package:redux/redux.dart';

final onBoardingPageReducer = combineReducers<OnBoardingFlowPageState>([
  TypedReducer<OnBoardingFlowPageState, UpdatePushNotificationEnabled>(_setPushNotificationsState),
  TypedReducer<OnBoardingFlowPageState, UpdateCalendarEnabled>(_setCalendarState),
  TypedReducer<OnBoardingFlowPageState, IncrementPagerIndexAction>(_incrementPagerIndex),
  TypedReducer<OnBoardingFlowPageState, DecrementPagerIndexAction>(_decrementPagerIndex),
  TypedReducer<OnBoardingFlowPageState, SaveTermsAndPrivacyStateAction>(_saveTermsAndPrivacyState),
  TypedReducer<OnBoardingFlowPageState, ValidateStateForNextStepAction>(_checkForTermsAndPrivacyChecked),
  TypedReducer<OnBoardingFlowPageState, SaveSkipAllStateAction>(_setErrorState)
]);

OnBoardingFlowPageState _setErrorState(OnBoardingFlowPageState previousState, SaveSkipAllStateAction action){
  return previousState.copyWith(
    showTermsAndPrivacyError: !action.pageState.termsAndPrivacyChecked,
  );
}

OnBoardingFlowPageState _checkForTermsAndPrivacyChecked(OnBoardingFlowPageState previousState, ValidateStateForNextStepAction action){
  return previousState.copyWith(
    showTermsAndPrivacyError: !action.pageState.termsAndPrivacyChecked,
  );
}

OnBoardingFlowPageState _incrementPagerIndex(OnBoardingFlowPageState previousState, IncrementPagerIndexAction action){
  int newIndex = action.pageState.pagerIndex + 1;
  return previousState.copyWith(
    pagerIndex: newIndex,
  );
}

OnBoardingFlowPageState _decrementPagerIndex(OnBoardingFlowPageState previousState, DecrementPagerIndexAction action){
  int newIndex = action.pageState.pagerIndex > 0 ? action.pageState.pagerIndex - 1 : action.pageState.pagerIndex;
  return previousState.copyWith(
    pagerIndex: newIndex,
  );
}

OnBoardingFlowPageState _saveTermsAndPrivacyState(OnBoardingFlowPageState previousState, SaveTermsAndPrivacyStateAction action){
  return previousState.copyWith(
    termsAndPrivacyChecked: action.isChecked,
    showTermsAndPrivacyError: action.isChecked ? false : action.pageState.showTermsAndPrivacyError,
  );
}


OnBoardingFlowPageState _setPushNotificationsState(OnBoardingFlowPageState previousState, UpdatePushNotificationEnabled action){
  return previousState.copyWith(
    pushNotificationsEnabled: action.enabled,
  );
}

OnBoardingFlowPageState _setCalendarState(OnBoardingFlowPageState previousState, UpdateCalendarEnabled action){
  return previousState.copyWith(
    calendarEnabled: action.enabled,
  );
}
