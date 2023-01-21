import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageActions.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
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
    purchases.CustomerInfo subscriptionState = await _getSubscriptionState();
    ManageSubscriptionPageState pageState = store.state.manageSubscriptionPageState;
    double annualPrice = 0;
    double monthlyPrice = 0;
    try {
      purchases.Offerings offerings = await purchases.Purchases.getOfferings();
      if (offerings.current != null && offerings.current.availablePackages.isNotEmpty) {
        String identifier = action.profile.isBetaTester ? 'Beta Discount Standard' : 'Standard';
        annualPrice = offerings?.getOffering(identifier)?.annual?.storeProduct?.price;
        monthlyPrice = offerings?.getOffering(identifier)?.monthly?.storeProduct?.price;
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
    store.dispatch(SetManageSubscriptionStateAction(store.state.manageSubscriptionPageState, subscriptionState, monthlyPrice, annualPrice));
  }

  void subscribe(Store<AppState> store, NextDispatcher next, SubscribeSelectedAction action) async{
    try {
      purchases.CustomerInfo purchaserInfo = await purchases.Purchases.purchasePackage(action.pageState.selectedSubscription);
      if (purchaserInfo.entitlements.all["standard"].isActive) {

      }
    } on PlatformException catch (e) {
      var errorCode = purchases.PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != purchases.PurchasesErrorCode.purchaseCancelledError) {
        //show error
      }
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