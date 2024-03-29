import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/Profile.dart';

class SubscribeSelectedAction{
  final ManageSubscriptionPageState? pageState;
  SubscribeSelectedAction(this.pageState);
}

class RestoreSubscriptionAction{
  final ManageSubscriptionPageState? pageState;
  RestoreSubscriptionAction(this.pageState);
}

class SetManageSubscriptionStateAction{
  final ManageSubscriptionPageState? pageState;
  final CustomerInfo? subscriptionState;
  final Offerings? offerings;
  final Profile? profile;
  final double? monthlyPrice;
  final double? annualPrice;
  SetManageSubscriptionStateAction(this.pageState, this.subscriptionState, this.monthlyPrice, this.annualPrice, this.offerings, this.profile);
}

class SetLoadingState {
  final ManageSubscriptionPageState? pageState;
  final bool? isLoading;
  final bool? shouldPopBack;
  SetLoadingState(this.pageState, this.isLoading, this.shouldPopBack);
}

class SetManageSubscriptionUiState {
  final ManageSubscriptionPageState? pageState;
  final String? uiState;
  SetManageSubscriptionUiState(this.pageState, this.uiState);
}

class SetInitialDataAction{
  final ManageSubscriptionPageState? pageState;
  final CustomerInfo? subscriptionState;
  final Profile? profile;
  SetInitialDataAction(this.pageState, this.subscriptionState, this.profile);
}

class FetchInitialDataAction{
  final ManageSubscriptionPageState? pageState;
  final Profile? profile;
  FetchInitialDataAction(this.pageState, this.profile);
}

class SubscriptionSelectedAction{
  final ManageSubscriptionPageState? pageState;
  final String? package;
  SubscriptionSelectedAction(this.pageState, this.package);
}

class ResetErrorMsgAction {
  final ManageSubscriptionPageState? pageState;
  ResetErrorMsgAction(this.pageState);
}

class SetErrorMsgAction {
  final ManageSubscriptionPageState? pageState;
  final String? errorMsg;
  SetErrorMsgAction(this.pageState, this.errorMsg);
}

class ValidateCodeAction {
  final ManageSubscriptionPageState? pageState;
  final String? discountCode;
  ValidateCodeAction(this.pageState, this.discountCode);
}

class SetShowDiscountErrorStateAction {
  final ManageSubscriptionPageState? pageState;
  final bool? showError;
  SetShowDiscountErrorStateAction(this.pageState, this.showError);
}

class AssignDiscountCodeToUser {
  final ManageSubscriptionPageState? pageState;
  AssignDiscountCodeToUser(this.pageState);
}

class SetDiscountCodeAction {
  final ManageSubscriptionPageState? pageState;
  final String? discountCode;
  SetDiscountCodeAction(this.pageState, this.discountCode);
}

class SetDiscountTypeAction {
  final ManageSubscriptionPageState? pageState;
  final String? discountType;
  SetDiscountTypeAction(this.pageState, this.discountType);
}

class SetShowAppliedDiscountAction {
  final ManageSubscriptionPageState? pageState;
  final bool? showAppliedDiscount;
  SetShowAppliedDiscountAction(this.pageState, this.showAppliedDiscount);
}

class SetProfileAction {
  final ManageSubscriptionPageState? pageState;
  final Profile? profile;
  SetProfileAction(this.pageState, this.profile);
}