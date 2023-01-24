import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageActions.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:redux/redux.dart';
import 'ManageSubscriptionPageState.dart';

final manageSubscriptionPageReducer = combineReducers<ManageSubscriptionPageState>([
  TypedReducer<ManageSubscriptionPageState, SetManageSubscriptionStateAction>(_setSubscriptionState),
  TypedReducer<ManageSubscriptionPageState, SetInitialDataAction>(_setInitialData),
  TypedReducer<ManageSubscriptionPageState, SubscriptionSelectedAction>(_setSelectedSubscription),
  TypedReducer<ManageSubscriptionPageState, ResetErrorMsgAction>(_resetErrorMsg),
  TypedReducer<ManageSubscriptionPageState, SetErrorMsgAction>(_setErrorMsg),
  TypedReducer<ManageSubscriptionPageState, SetManageSubscriptionUiState>(_setUiState),
  TypedReducer<ManageSubscriptionPageState, SetLoadingState>(_setLoadingState),
]);

ManageSubscriptionPageState _setLoadingState(ManageSubscriptionPageState previousState, SetLoadingState action){
  return previousState.copyWith(
    isLoading: action.isLoading,
  );
}

ManageSubscriptionPageState _setUiState(ManageSubscriptionPageState previousState, SetManageSubscriptionUiState action){
  return previousState.copyWith(
    uiState: action.uiState,
  );
}

ManageSubscriptionPageState _setErrorMsg(ManageSubscriptionPageState previousState, SetErrorMsgAction action){
  return previousState.copyWith(
    errorMsg: action.errorMsg,
  );
}

ManageSubscriptionPageState _resetErrorMsg(ManageSubscriptionPageState previousState, ResetErrorMsgAction action){
  return previousState.copyWith(
    errorMsg: '',
  );
}

ManageSubscriptionPageState _setSubscriptionState(ManageSubscriptionPageState previousState, SetManageSubscriptionStateAction action){
  Offering offering = null;
  if(action.profile.isBetaTester) {
    offering = action.offerings.getOffering('Beta Discount Standard');
  } else {
    offering = action.offerings.getOffering('Standard');
  }

  Package selectedSubscription = offering.annual;
  int radioValue = 0;
  if(action.subscriptionState.entitlements.all['standard'].isActive) {
    if(action.subscriptionState.activeSubscriptions.contains('dandylight_beta_tester_subscription') || action.subscriptionState.activeSubscriptions.contains('dandylight_standard_subscription')) {
      selectedSubscription = offering.monthly;
      radioValue = 1;
    } else if(action.subscriptionState.activeSubscriptions.contains('dandylight_annual_subscription') || action.subscriptionState.activeSubscriptions.contains('dandylight_beta_tester_annual_subscription')) {
      selectedSubscription = offering.annual;
      radioValue = 0;
    }
  }
  return previousState.copyWith(
    subscriptionState: action.subscriptionState,
    monthlyPrice: action.monthlyPrice,
    monthlyPackage: offering.monthly,
    annualPrice: action.annualPrice,
    annualPackage: offering.annual,
    offerings: action.offerings,
    selectedSubscription: selectedSubscription,
    radioValue: radioValue,
  );
}

ManageSubscriptionPageState _setInitialData(ManageSubscriptionPageState previousState, SetInitialDataAction action) {
  return previousState.copyWith(
    profile: action.profile,
    subscriptionState: action.subscriptionState,
  );
}

ManageSubscriptionPageState _setSelectedSubscription(ManageSubscriptionPageState previousState, SubscriptionSelectedAction action) {
  return previousState.copyWith(
    selectedSubscription: action.package,
    radioValue: action.package == action.pageState.annualPackage ? 0 : 1,
  );
}