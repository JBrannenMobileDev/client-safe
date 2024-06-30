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
  Offering? offering;
  double monthlyPrice = 9.99;
  double annualPrice = 99.99;

  switch(action.discountType) {
    case DiscountCodes.A_LITTLE_STORY_30:
      offering = previousState.offerings!.getOffering('Discount 30%');
      monthlyPrice = 6.99;
      annualPrice = 69.99;
      break;
    case DiscountCodes.LIFETIME_FREE:
      offering = null;
      monthlyPrice = 0.00;
      annualPrice = 0.00;
      break;
    case DiscountCodes.FIFTY_PERCENT_TYPE:
      offering = previousState.offerings!.getOffering('Beta Discount Standard');
      monthlyPrice = 4.99;
      annualPrice = 49.99;
      break;
    case DiscountCodes.FIRST_3_MONTHS_FREE:
      offering = previousState.offerings!.getOffering('3_months_free');
      break;
    default:
      if (previousState.offerings != null) {
        if(previousState.profile!.isBetaTester!) {
          offering = previousState.offerings!.getOffering('Beta Discount Standard');
        } else {
          offering = previousState.offerings!.getOffering('Standard');
        }
      }
      monthlyPrice = previousState.monthlyPrice!;
      annualPrice = previousState.annualPrice!;
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
  Offering? offering;
  double annualPrice = 0;
  double monthlyPrice = 0;

  if(action.profile!.isBetaTester!) {
    if(action.offerings != null) {
      offering = action.offerings!.getOffering('Beta Discount Standard');
    }
    annualPrice = 49.99;
    monthlyPrice = 4.99;
  } else {
    String identifier = 'Standard';

    if(action.offerings != null) {
      offering = action.offerings!.getOffering(identifier);
      if(offering != null) {
        annualPrice = offering.annual!.storeProduct.price;
        monthlyPrice = offering.monthly!.storeProduct.price;
      }
    } else {
      annualPrice = 99.99;
      monthlyPrice = 9.99;
    }
  }

  String? selectedSubscription;
  int radioValue = 0;

  if(offering != null) {
    annualPrice = offering.annual!.storeProduct.price;
    monthlyPrice = offering.monthly!.storeProduct.price;
    selectedSubscription = ManageSubscriptionPage.PACKAGE_ANNUAL;

    if(action.subscriptionState!.entitlements.all['standard'] != null) {
      if(action.subscriptionState!.entitlements.all['standard']!.isActive) {
        if(action.subscriptionState!.activeSubscriptions.contains('monthly_half_off') || action.subscriptionState!.activeSubscriptions.contains('monthly_subscription') || action.subscriptionState!.activeSubscriptions.contains('monthly:standard') || action.subscriptionState!.activeSubscriptions.contains('monthly_half_off:monthly-half-off-base') || action.subscriptionState!.activeSubscriptions.contains('monthly_1699') || action.subscriptionState!.activeSubscriptions.contains('monthly_discount_30') || action.subscriptionState!.activeSubscriptions.contains('monthly_1699:monthly-1699-base') || action.subscriptionState!.activeSubscriptions.contains('monthly_discount_30:monthly-discount-30') || action.subscriptionState!.activeSubscriptions.contains('annual_3_months_free') || action.subscriptionState!.activeSubscriptions.contains('annual_3_months_free:annual-three-months-free-base')) {
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_half_off') || action.subscriptionState!.activeSubscriptions.contains('monthly_half_off:monthly-half-off-base')) {
            offering = action.offerings!.getOffering('Beta Discount Standard');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_subscription') || action.subscriptionState!.activeSubscriptions.contains('monthly:standard')) {
            offering = action.offerings!.getOffering('Standard');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_1699') || action.subscriptionState!.activeSubscriptions.contains('monthly_1699:monthly-1699-base')) {
            offering = action.offerings!.getOffering('standard_1699');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_discount_30') || action.subscriptionState!.activeSubscriptions.contains('monthly_discount_30:monthly-discount-30')) {
            offering = action.offerings!.getOffering('Discount 30%');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_3_months_free') || action.subscriptionState!.activeSubscriptions.contains('monthly_3_months_free:1699-3-free-months')) {
            offering = action.offerings!.getOffering('3_months_free');
          }
          selectedSubscription = ManageSubscriptionPage.PACKAGE_MONTHLY;
          annualPrice = offering!.annual!.storeProduct.price;
          monthlyPrice = offering.monthly!.storeProduct.price;
          radioValue = 1;
        } else if(action.subscriptionState!.activeSubscriptions.contains('annual') || action.subscriptionState!.activeSubscriptions.contains('annual_half_off') || action.subscriptionState!.activeSubscriptions.contains('annual:annual-base') || action.subscriptionState!.activeSubscriptions.contains('annual_half_off:annual-half-off-base') || action.subscriptionState!.activeSubscriptions.contains('yearly_13999:yearly-13999') || action.subscriptionState!.activeSubscriptions.contains('yearly_204') || action.subscriptionState!.activeSubscriptions.contains('annual_discount_30') || action.subscriptionState!.activeSubscriptions.contains('annual_discount_30:annual-discount-30') || action.subscriptionState!.activeSubscriptions.contains('annual_3_months_free') || action.subscriptionState!.activeSubscriptions.contains('annual_3_months_free:annual-three-months-free-base')) {
          if(action.subscriptionState!.activeSubscriptions.contains('annual_half_off') || action.subscriptionState!.activeSubscriptions.contains('annual_half_off:annual-half-off-base')) {
            offering = action.offerings!.getOffering('Beta Discount Standard');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('annual') || action.subscriptionState!.activeSubscriptions.contains('annual:annual-base')) {
            offering = action.offerings!.getOffering('Standard');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('yearly_204') || action.subscriptionState!.activeSubscriptions.contains('yearly_13999:yearly-13999')) {
            offering = action.offerings!.getOffering('standard_1699');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('annual_discount_30') || action.subscriptionState!.activeSubscriptions.contains('annual_discount_30:annual-discount-30')) {
            offering = action.offerings!.getOffering('Discount 30%');
          }
          if(action.subscriptionState!.activeSubscriptions.contains('monthly_3_months_free') || action.subscriptionState!.activeSubscriptions.contains('monthly_3_months_free:1699-3-free-months')) {
            offering = action.offerings!.getOffering('3_months_free');
          }

          selectedSubscription = ManageSubscriptionPage.PACKAGE_ANNUAL;
          annualPrice = offering!.annual!.storeProduct.price;
          monthlyPrice = offering.monthly!.storeProduct.price;
          radioValue = 0;
        }
      }
    }
  }

  String timeLeftMessage = 'Dandylight is free to use with a limit to the amount of jobs that can be created(3). Select a subscription option below to unlock unlimited access to these features. The details are listed below.';


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
  String timeLeftMessage = 'Dandylight is free to use with a limit to the amount of jobs that can be created(3). Select a subscription option below to unlock unlimited access to these features. The details are listed below.';

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