import 'package:dandylight/AppState.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';

import '../../models/Profile.dart';
import 'ManageSubscriptionPage.dart';
import 'ManageSubscriptionPageActions.dart';

class ManageSubscriptionPageState {
  final int radioValue;
  final String uiState;
  final String errorMsg;
  final double annualPrice;
  final double monthlyPrice;
  final bool isLoading;
  final purchases.CustomerInfo subscriptionState;
  final purchases.Package selectedSubscription;
  final purchases.Package monthlyPackage;
  final purchases.Package annualPackage;
  final Profile profile;
  final purchases.Offerings offerings;
  final Function() onSubscribeSelected;
  final Function() onRestoreSubscriptionSelected;
  final Function(purchases.Package) onSubscriptionSelected;
  final Function() resetErrorMsg;
  final Function(String) setErrorMsg;

  ManageSubscriptionPageState({
    @required this.uiState,
    @required this.selectedSubscription,
    @required this.profile,
    @required this.offerings,
    @required this.onSubscribeSelected,
    @required this.onRestoreSubscriptionSelected,
    @required this.onSubscriptionSelected,
    @required this.subscriptionState,
    @required this.annualPrice,
    @required this.monthlyPrice,
    @required this.errorMsg,
    @required this.resetErrorMsg,
    @required this.setErrorMsg,
    @required this.monthlyPackage,
    @required this.annualPackage,
    @required this.isLoading,
    @required this.radioValue,
  });

  ManageSubscriptionPageState copyWith({
    int radioValue,
    String uiState,
    String errorMsg,
    purchases.Package selectedSubscription,
    purchases.Package monthlyPackage,
    purchases.Package annualPackage,
    Profile profile,
    purchases.CustomerInfo subscriptionState,
    double annualPrice,
    double monthlyPrice,
    bool isLoading,
    purchases.Offerings offerings,
    Function() onSubscribeSelected,
    Function() onRestoreSubscriptionSelected,
    Function(purchases.Package) onSubscriptionSelected,
    Function() resetErrorMsg,
    Function(String) setErrorMsg,
  }){
    return ManageSubscriptionPageState(
      uiState: uiState?? this.uiState,
      selectedSubscription: selectedSubscription?? this.selectedSubscription,
      profile: profile?? this.profile,
      offerings: offerings?? this.offerings,
      onSubscribeSelected: onSubscribeSelected?? this.onSubscribeSelected,
      onRestoreSubscriptionSelected: onRestoreSubscriptionSelected?? this.onRestoreSubscriptionSelected,
      onSubscriptionSelected: onSubscriptionSelected ?? this.onSubscriptionSelected,
      subscriptionState: subscriptionState ?? this.subscriptionState,
      annualPrice: annualPrice ?? this.annualPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      errorMsg: errorMsg ?? this.errorMsg,
      resetErrorMsg: resetErrorMsg ?? this.resetErrorMsg,
      setErrorMsg: setErrorMsg ?? this.setErrorMsg,
      monthlyPackage: monthlyPackage ?? this.monthlyPackage,
      annualPackage: annualPackage ?? this.annualPackage,
      isLoading: isLoading ?? this.isLoading,
      radioValue: radioValue ?? this.radioValue,
    );
  }

  factory ManageSubscriptionPageState.initial() => ManageSubscriptionPageState(
    uiState: ManageSubscriptionPage.FREE_TRIAL,
    selectedSubscription: null,
    profile: null,
    offerings: null,
    onSubscribeSelected: null,
    onRestoreSubscriptionSelected: null,
    onSubscriptionSelected: null,
    subscriptionState: null,
    annualPrice: 0,
    monthlyPrice: 0,
    errorMsg: '',
    resetErrorMsg: null,
    setErrorMsg: null,
    monthlyPackage: null,
    annualPackage: null,
    isLoading: false,
    radioValue: 0,
  );

  factory ManageSubscriptionPageState.fromStore(Store<AppState> store) {
    return ManageSubscriptionPageState(
      uiState: store.state.manageSubscriptionPageState.uiState,
      selectedSubscription: store.state.manageSubscriptionPageState.selectedSubscription,
      profile: store.state.manageSubscriptionPageState.profile,
      offerings: store.state.manageSubscriptionPageState.offerings,
      subscriptionState: store.state.manageSubscriptionPageState.subscriptionState,
      annualPrice: store.state.manageSubscriptionPageState.annualPrice,
      monthlyPrice: store.state.manageSubscriptionPageState.monthlyPrice,
      errorMsg: store.state.manageSubscriptionPageState.errorMsg,
      monthlyPackage: store.state.manageSubscriptionPageState.monthlyPackage,
      annualPackage: store.state.manageSubscriptionPageState.annualPackage,
      isLoading: store.state.manageSubscriptionPageState.isLoading,
      radioValue: store.state.manageSubscriptionPageState.radioValue,
      onSubscribeSelected: () => store.dispatch(SubscribeSelectedAction(store.state.manageSubscriptionPageState)),
      onRestoreSubscriptionSelected: () => store.dispatch(RestoreSubscriptionAction(store.state.manageSubscriptionPageState)),
      onSubscriptionSelected: (package) => store.dispatch(SubscriptionSelectedAction(store.state.manageSubscriptionPageState, package)),
      resetErrorMsg: () => store.dispatch(ResetErrorMsgAction(store.state.manageSubscriptionPageState)),
      setErrorMsg: (errorMsg) => store.dispatch(SetErrorMsgAction(store.state.manageSubscriptionPageState, errorMsg)),
    );
  }

  @override
  int get hashCode =>
      uiState.hashCode ^
      selectedSubscription.hashCode ^
      profile.hashCode ^
      offerings.hashCode ^
      onSubscribeSelected.hashCode ^
      onRestoreSubscriptionSelected.hashCode ^
      subscriptionState.hashCode ^
      annualPrice.hashCode ^
      monthlyPrice.hashCode ^
      errorMsg.hashCode ^
      resetErrorMsg.hashCode ^
      setErrorMsg.hashCode ^
      monthlyPackage.hashCode ^
      annualPackage.hashCode ^
      isLoading.hashCode ^
      radioValue.hashCode ^
      onSubscriptionSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManageSubscriptionPageState &&
          uiState == other.uiState &&
          selectedSubscription == other.selectedSubscription &&
          profile == other.profile &&
          offerings == other.offerings &&
          onSubscribeSelected == other.onSubscribeSelected &&
          onRestoreSubscriptionSelected == other.onRestoreSubscriptionSelected &&
          subscriptionState == other.subscriptionState &&
          annualPrice == other.annualPrice &&
          monthlyPrice == other.monthlyPrice &&
          errorMsg == other.errorMsg &&
          setErrorMsg == other.setErrorMsg &&
          resetErrorMsg == other.resetErrorMsg &&
          monthlyPackage == other.monthlyPackage &&
          annualPackage == other.annualPackage &&
          isLoading == other.isLoading &&
          radioValue == other.radioValue &&
          onSubscriptionSelected == other.onSubscriptionSelected;
}
