import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageActions.dart';
import 'package:redux/redux.dart';
import 'ManageSubscriptionPageState.dart';

final manageSubscriptionPageReducer = combineReducers<ManageSubscriptionPageState>([
  TypedReducer<ManageSubscriptionPageState, SetManageSubscriptionStateAction>(_setSubscriptionState),
  TypedReducer<ManageSubscriptionPageState, SetInitialDataAction>(_setInitialData),
  TypedReducer<ManageSubscriptionPageState, SubscriptionSelectedAction>(_setSelectedSubscription),
]);

ManageSubscriptionPageState _setSubscriptionState(ManageSubscriptionPageState previousState, SetManageSubscriptionStateAction action){
  return previousState.copyWith(
    subscriptionState: action.subscriptionState,
    monthlyPrice: action.monthlyPrice,
    annualPrice: action.annualPrice,
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
  );
}