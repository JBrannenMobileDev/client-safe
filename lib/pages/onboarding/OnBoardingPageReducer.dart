import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'OnBoardingActions.dart';

final onBoardingReducer = combineReducers<OnBoardingPageState>([
  TypedReducer<OnBoardingPageState, SetFeatureSelectedStateAction>(_setSelectedFeature),
  TypedReducer<OnBoardingPageState, SetPagerIndexAction>(_setPagerIndex),
  TypedReducer<OnBoardingPageState, SetHasJobAnswerAction>(_setHasJobAnswer),
]);

OnBoardingPageState _setHasJobAnswer(OnBoardingPageState previousState, SetHasJobAnswerAction action){
  return previousState.copyWith(
    selectedOptionHasJob: action.answer,
  );
}

OnBoardingPageState _setPagerIndex(OnBoardingPageState previousState, SetPagerIndexAction action){
  if(previousState.pagerIndex == 1 && action.index == 2) {
    if(action.pageState.jobTrackingSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Job Tracking',
    });
    if(action.pageState.incomeExpensesSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Income & Expenses',
    });
    if(action.pageState.posesSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Poses',
    });
    if(action.pageState.invoicesSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Invoices',
    });
    if(action.pageState.mileageTrackingSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Mileage Tracking',
    });
    if(action.pageState.analyticsSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Business Analytics',
    });
    if(action.pageState.otherSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Other',
    });
    if(action.pageState.otherSelected) EventSender().sendEvent(eventName: EventNames.ON_BOARDING_FEATURE_CHOSEN, properties: {
      EventNames.ON_BOARDING_FEATURE_CHOSEN_PARAM : 'Contracts',
    });
  }
  return previousState.copyWith(
      pagerIndex: action.index,
  );
}

OnBoardingPageState _setSelectedFeature(OnBoardingPageState previousState, SetFeatureSelectedStateAction action){
  bool jobTracking = previousState.jobTrackingSelected;
  bool incomeExpenses = previousState.incomeExpensesSelected;
  bool poses = previousState.posesSelected;
  bool invoices = previousState.invoicesSelected;
  bool analytics = previousState.analyticsSelected;
  bool mileageTracking = previousState.mileageTrackingSelected;
  bool contracts = previousState.contractsSelected;
  bool other = previousState.otherSelected;

  switch(action.featureName) {
    case OnBoardingPageState.JOB_TRACKING:
      jobTracking = action.isSelected;
      break;
    case OnBoardingPageState.INCOME_EXPENSES:
      incomeExpenses = action.isSelected;
      break;
    case OnBoardingPageState.POSES:
      poses = action.isSelected;
      break;
    case OnBoardingPageState.INVOICES:
      invoices = action.isSelected;
      break;
    case OnBoardingPageState.BUSINESS_ANALYTICS:
      analytics = action.isSelected;
      break;
    case OnBoardingPageState.MILEAGE_TRACKING:
      mileageTracking = action.isSelected;
      break;
    case OnBoardingPageState.OTHER:
      other = action.isSelected;
      break;
    case OnBoardingPageState.CONTRACTS:
      contracts = action.isSelected;
  }

  return previousState.copyWith(
    jobTrackingSelected: jobTracking,
    incomeExpensesSelected: incomeExpenses,
    posesSelected: poses,
    invoicesSelected: invoices,
    analyticsSelected: analytics,
    mileageTrackingSelected: mileageTracking,
    otherSelected: other,
    contractsSelected: contracts,
    featuresContinueEnabled: jobTracking || incomeExpenses || poses || invoices || analytics || mileageTracking || other || contracts
  );
}
