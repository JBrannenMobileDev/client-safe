import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
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
  TypedReducer<ManageSubscriptionPageState, SetDiscountCodeAction>(_setDiscountCode),
  TypedReducer<ManageSubscriptionPageState, SetShowDiscountErrorStateAction>(_setErrorState),
  TypedReducer<ManageSubscriptionPageState, SetDiscountTypeAction>(_setDiscountType),
  TypedReducer<ManageSubscriptionPageState, SetShowAppliedDiscountAction>(_setShowAppliedDiscount),
  TypedReducer<ManageSubscriptionPageState, SetProfileAction>(_setProfile),
]);

ManageSubscriptionPageState _setProfile(ManageSubscriptionPageState previousState, SetProfileAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

ManageSubscriptionPageState _setShowAppliedDiscount(ManageSubscriptionPageState previousState, SetShowAppliedDiscountAction action){
  return previousState.copyWith(
    showAppliedDiscount: action.showAppliedDiscount,
  );
}

ManageSubscriptionPageState _setDiscountType(ManageSubscriptionPageState previousState, SetDiscountTypeAction action){
  Offering offering = null;
  double monthlyPrice = 9.99;
  double annualPrice = 99.99;

  switch(action.discountType) {
    case DiscountCodes.LIFETIME_FREE:
      offering = null;
      monthlyPrice = 0.00;
      annualPrice = 0.00;
      break;
    case DiscountCodes.FIFTY_PERCENT_TYPE:
      offering = previousState.offerings.getOffering('Beta Discount Standard');
      monthlyPrice = 4.99;
      annualPrice = 49.99;
      break;
    default:
      if (previousState.offerings != null) {
        if(previousState.profile.isBetaTester) {
          offering = previousState.offerings.getOffering('Beta Discount Standard');
        } else {
          offering = previousState.offerings.getOffering('Standard');
        }
      }
      monthlyPrice = previousState.monthlyPrice;
      annualPrice = previousState.annualPrice;
  }
  return previousState.copyWith(
    annualPrice: annualPrice,
    annualPackage: offering?.annual,
    monthlyPrice: monthlyPrice,
    monthlyPackage: offering?.monthly,
    discountType: action.discountType,
  );
}

ManageSubscriptionPageState _setErrorState(ManageSubscriptionPageState previousState, SetShowDiscountErrorStateAction action){
  return previousState.copyWith(
    showDiscountError: action.showError,
  );
}

ManageSubscriptionPageState _setDiscountCode(ManageSubscriptionPageState previousState, SetDiscountCodeAction action){
  return previousState.copyWith(
    discountCode: action.discountCode,
  );
}

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
  double annualPrice = 0;
  double monthlyPrice = 0;

  if(action.profile.isBetaTester) {
    if(action.offerings != null) {
      offering = action.offerings.getOffering('Beta Discount Standard');
    }
    annualPrice = 49.99;
    monthlyPrice = 4.99;
  } else {
    if(action.offerings != null) {
      offering = action.offerings.getOffering('Standard');
    }
    annualPrice = 99.99;
    monthlyPrice = 9.99;
  }

  String selectedSubscription = null;
  int radioValue = 0;

  if(offering != null) {
    annualPrice = offering.annual.storeProduct.price;
    monthlyPrice = offering.monthly.storeProduct.price;
    selectedSubscription = ManageSubscriptionPage.PACKAGE_ANNUAL;

    if(action.subscriptionState.entitlements.all['standard'] != null) {
      if(action.subscriptionState.entitlements.all['standard'].isActive) {
        if(action.subscriptionState.activeSubscriptions.contains('monthly_half_off') || action.subscriptionState.activeSubscriptions.contains('monthly_subscription') || action.subscriptionState.activeSubscriptions.contains('monthly:standard') || action.subscriptionState.activeSubscriptions.contains('monthly_half_off:monthly-half-off-base')) {
          selectedSubscription = ManageSubscriptionPage.PACKAGE_MONTHLY;
          radioValue = 1;
        } else if(action.subscriptionState.activeSubscriptions.contains('annual') || action.subscriptionState.activeSubscriptions.contains('annual_half_off') || action.subscriptionState.activeSubscriptions.contains('annual:annual-base') || action.subscriptionState.activeSubscriptions.contains('annual_half_off:annual-half-off-base')) {
          selectedSubscription = ManageSubscriptionPage.PACKAGE_ANNUAL;
          annualPrice = offering.annual.storeProduct.price;
          monthlyPrice = offering.monthly.storeProduct.price;
          radioValue = 0;
        }
      }
    }
  }

  DateTime expirationTime = action.profile.accountCreatedDate.add(Duration(days: 14));
  DateTime current = DateTime.now();

  DateTime from = DateTime(current.year, current.month, current.day);
  DateTime to = DateTime(expirationTime.year, expirationTime.month, expirationTime.day);
  int daysBetween = (to.difference(from).inHours / 24).round();

  if(current.isAfter(expirationTime)) {
    daysBetween = 0;
  }

  String timeLeftMessage = daysBetween.toString() + (daysBetween == 1 ? ' day' : ' days') + ' remaining of your 14 day free trial. When the free trial ends you will not be charged. You will be required to subscribe at the end of the trial period to continue using our service.';


  return previousState.copyWith(
    subscriptionState: action.subscriptionState,
    monthlyPrice: monthlyPrice,
    monthlyPackage: offering?.monthly,
    annualPrice: annualPrice,
    annualPackage: offering?.annual,
    offerings: action.offerings,
    selectedSubscription: selectedSubscription,
    radioValue: radioValue,
    profile: action.profile,
    remainingTimeMessage: timeLeftMessage,
  );
}

ManageSubscriptionPageState _setInitialData(ManageSubscriptionPageState previousState, SetInitialDataAction action) {
  DateTime expirationTime = action.profile.accountCreatedDate.add(Duration(days: 14));
  DateTime current = DateTime.now();

  DateTime from = DateTime(current.year, current.month, current.day);
  DateTime to = DateTime(expirationTime.year, expirationTime.month, expirationTime.day);
  int daysBetween = (to.difference(from).inHours / 24).round();

  if(current.isAfter(expirationTime)) {
    daysBetween = 0;
  }

  String timeLeftMessage = daysBetween.toString() + (daysBetween == 1 ? ' Day' : ' Days') + 'remaining of your 14 day free trial. When the free trial ends you will not be charged. Your will be required to subscribe at the end of the trial period to continue using our service.';

  return previousState.copyWith(
    profile: action.profile,
    subscriptionState: action.subscriptionState,
    remainingTimeMessage: timeLeftMessage,
  );
}

ManageSubscriptionPageState _setSelectedSubscription(ManageSubscriptionPageState previousState, SubscriptionSelectedAction action) {
  return previousState.copyWith(
    selectedSubscription: action.package,
    radioValue: action.package == ManageSubscriptionPage.PACKAGE_ANNUAL ? 0 : 1,
  );
}