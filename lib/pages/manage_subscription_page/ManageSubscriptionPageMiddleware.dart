import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/DiscountCodesDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/repositories/DiscountCodesRepository.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageActions.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/errors.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';

import '../../models/Code.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

class ManageSubscriptionPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchInitialDataAction){
      fetchData(store, next, action);
    }
    if(action is SubscribeSelectedAction) {
      subscribe(store, next, action);
    }
    if(action is ValidateCodeAction) {
      validateCode(store, next, action);
    }
    if(action is AssignDiscountCodeToUser) {
      assignDiscountCode(store, next, action);
    }
  }

  void assignDiscountCode(Store<AppState> store, NextDispatcher next, AssignDiscountCodeToUser action) async{

  }

  void validateCode(Store<AppState> store, NextDispatcher next, ValidateCodeAction action) async{
    DiscountCodesRepository repo = DiscountCodesRepository();
    String discountType = await repo.getMatchingDiscount(action.discountCode);

    if(discountType.isNotEmpty) {
      store.dispatch(SetDiscountTypeAction(store.state.manageSubscriptionPageState, discountType));
      store.dispatch(SetDiscountCodeAction(store.state.manageSubscriptionPageState, action.discountCode));
      if(discountType == DiscountCodes.LIFETIME_FREE) {
        DiscountCodesRepository repo = DiscountCodesRepository();
        Profile profile = await ProfileDao.getMatchingProfile(action.pageState.profile.uid);
        profile.isFreeForLife = true;
        await ProfileDao.update(profile);
        repo.assignUserToCode(action.pageState.discountCode, store.state.dashboardPageState.profile.uid);
        store.dispatch(SetProfileAction(store.state.manageSubscriptionPageState, profile));
      }
    } else {
      store.dispatch(SetShowDiscountErrorStateAction(store.state.manageSubscriptionPageState, true));
    }
  }

  void fetchData(Store<AppState> store, NextDispatcher next, FetchInitialDataAction action) async{
    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, true, false));
    purchases.CustomerInfo subscriptionState = await _getSubscriptionState();
    double annualPrice = 0;
    double monthlyPrice = 0;
    purchases.Offerings offerings = null;
    try {
      offerings = await purchases.Purchases.getOfferings();
      if (offerings != null) {
        store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false, false));
        String identifier = action.profile.isBetaTester ? 'Beta Discount Standard' : (DateTime.now().isBefore(DateTime(2023, 12, 1)) ? 'Standard' : 'standard_1699');
        annualPrice = offerings?.getOffering(identifier)?.annual?.storeProduct?.price;
        monthlyPrice = offerings?.getOffering(identifier)?.monthly?.storeProduct?.price;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        //do nothing
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        store.dispatch(SetErrorMsgAction(store.state.manageSubscriptionPageState, errorCode.name));
      }
    }

    if(subscriptionState.entitlements.all['standard'] != null) {
      if(subscriptionState.entitlements.all['standard'].isActive) {
        store.dispatch(SetManageSubscriptionUiState(store.state.manageSubscriptionPageState, ManageSubscriptionPage.SUBSCRIBED));
        await EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIBED);
      } else {
        store.dispatch(SetManageSubscriptionUiState(store.state.manageSubscriptionPageState, ManageSubscriptionPage.SUBSCRIPTION_EXPIRED));
        await EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIPTION_EXPIRED);
      }
    } else {
      await EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.FREE_TRIAL);
    }

    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false, false));
    store.dispatch(SetManageSubscriptionStateAction(store.state.manageSubscriptionPageState, subscriptionState, monthlyPrice, annualPrice, offerings, action.profile));
    await DiscountCodesDao.syncAllFromFireStore();
  }

  void subscribe(Store<AppState> store, NextDispatcher next, SubscribeSelectedAction action) async{
    store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, true, false));
    try {
      purchases.Package package = action.pageState.annualPackage;
      switch(action.pageState.selectedSubscription) {
        case ManageSubscriptionPage.PACKAGE_ANNUAL:
          package = action.pageState.annualPackage;
          break;
        case ManageSubscriptionPage.PACKAGE_MONTHLY:
          package = action.pageState.monthlyPackage;
          break;
      }

        purchases.CustomerInfo purchaserInfo = await purchases.Purchases.purchasePackage(package);
        if (purchaserInfo.entitlements.all["standard"].isActive) {
          store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false, true));
          store.dispatch(SetManageSubscriptionUiState(store.state.manageSubscriptionPageState, ManageSubscriptionPage.SUBSCRIBED));
          Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
          profile.isSubscribed = true;
          ProfileDao.update(profile);
          EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.SUBSCRIBED);
          EventSender().sendEvent(eventName: EventNames.USER_SUBSCRIBED, properties: {
            EventNames.SUBSCRIPTION_PARAM_NAME : action.pageState.selectedSubscription,
          });
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        //do nothing
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        store.dispatch(SetErrorMsgAction(store.state.manageSubscriptionPageState, errorCode.name));
      }
      store.dispatch(SetLoadingState(store.state.manageSubscriptionPageState, false, false));
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