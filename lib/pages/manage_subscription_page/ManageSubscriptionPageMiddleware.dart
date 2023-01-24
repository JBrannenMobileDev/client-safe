import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageActions.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';

class ManageSubscriptionPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchInitialDataAction){
      fetchData(store, next, action);
    }
    if(action is SubscribeSelectedAction) {
      subscribe(store, next, action);
    }
  }

  void fetchData(Store<AppState> store, NextDispatcher next, FetchInitialDataAction action) async{
    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, true));
    purchases.CustomerInfo subscriptionState = await _getSubscriptionState();
    double annualPrice = 0;
    double monthlyPrice = 0;
    purchases.Offerings offerings = null;
    try {
      offerings = await purchases.Purchases.getOfferings();
      if (offerings != null) {
        store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false));
        String identifier = action.profile.isBetaTester ? 'Beta Discount Standard' : 'Standard';
        annualPrice = offerings?.getOffering(identifier)?.annual?.storeProduct?.price;
        monthlyPrice = offerings?.getOffering(identifier)?.monthly?.storeProduct?.price;
      }
    } on PlatformException catch (e) {
      store.dispatch(SetErrorMsgAction(store.state.manageSubscriptionPageState, e.message));
      store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false));
    }

    if(subscriptionState.entitlements.all['standard'] != null) {
      if(subscriptionState.entitlements.all['standard'].isActive) {
        store.dispatch(SetManageSubscriptionUiState(store.state.manageSubscriptionPageState, ManageSubscriptionPage.SUBSCRIBED));
      }
    }
    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false));
    store.dispatch(SetManageSubscriptionStateAction(store.state.manageSubscriptionPageState, subscriptionState, monthlyPrice, annualPrice, offerings, action.profile));
  }

  void subscribe(Store<AppState> store, NextDispatcher next, SubscribeSelectedAction action) async{
    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, true));
    try {
      purchases.CustomerInfo purchaserInfo = await purchases.Purchases.purchasePackage(action.pageState.selectedSubscription);
      if (purchaserInfo.entitlements.all["standard"].isActive) {
        store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false));
        store.dispatch(SetManageSubscriptionUiState(store.state.manageSubscriptionPageState, ManageSubscriptionPage.SUBSCRIBED));
      }
    } on PlatformException catch (e) {
      var errorCode = purchases.PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != purchases.PurchasesErrorCode.purchaseCancelledError) {
        store.dispatch(SetErrorMsgAction(store.state.manageSubscriptionPageState, errorCode.toString()));
      }
      store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false));
    }
  }

  Future<purchases.CustomerInfo> _getSubscriptionState() async {
    purchases.CustomerInfo currentInfo = null;
    try {
      currentInfo = await purchases.Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      // Error fetching customer info
    }
    return currentInfo;
  }
}