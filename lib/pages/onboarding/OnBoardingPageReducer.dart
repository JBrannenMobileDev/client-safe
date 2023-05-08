import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:redux/redux.dart';

import 'OnBoardingActions.dart';

final onBoardingReducer = combineReducers<OnBoardingPageState>([
  TypedReducer<OnBoardingPageState, SetFeatureSelectedStateAction>(_setSelectedFeature),
  TypedReducer<OnBoardingPageState, SetPagerIndexAction>(_setPagerIndex),
]);

OnBoardingPageState _setPagerIndex(OnBoardingPageState previousState, SetPagerIndexAction action){
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
  }

  return previousState.copyWith(
    jobTrackingSelected: jobTracking,
    incomeExpensesSelected: incomeExpenses,
    posesSelected: poses,
    invoicesSelected: invoices,
    analyticsSelected: analytics,
    featuresContinueEnabled: jobTracking || incomeExpenses || poses || invoices || analytics
  );
}
