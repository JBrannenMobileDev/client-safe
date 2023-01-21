import 'package:dandylight/AppState.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';

import '../../models/Profile.dart';
import 'ManageSubscriptionPage.dart';
import 'ManageSubscriptionPageActions.dart';

class ManageSubscriptionPageState {
  final String uiState;
  final double annualPrice;
  final double monthlyPrice;
  final purchases.CustomerInfo subscriptionState;
  final purchases.Package selectedSubscription;
  final Profile profile;
  final purchases.Offerings offerings;
  final Function() onSubscribeSelected;
  final Function() onRestoreSubscriptionSelected;
  final Function(purchases.Package) onSubscriptionSelected;

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
  });

  ManageSubscriptionPageState copyWith({
    String uiState,
    purchases.Package selectedSubscription,
    Profile profile,
    purchases.CustomerInfo subscriptionState,
    double annualPrice,
    double monthlyPrice,
    purchases.Offerings offerings,
    Function() onSubscribeSelected,
    Function() onRestoreSubscriptionSelected,
    Function(purchases.Package) onSubscriptionSelected,
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
    );
  }

  factory ManageSubscriptionPageState.initial() => ManageSubscriptionPageState(
    uiState: ManageSubscriptionPage.DEFAULT_SUBSCRIBE,
    selectedSubscription: null,
    profile: null,
    offerings: null,
    onSubscribeSelected: null,
    onRestoreSubscriptionSelected: null,
    onSubscriptionSelected: null,
    subscriptionState: null,
    annualPrice: 0,
    monthlyPrice: 0,
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
      onSubscribeSelected: () => store.dispatch(SubscribeSelectedAction(store.state.manageSubscriptionPageState)),
      onRestoreSubscriptionSelected: () => store.dispatch(RestoreSubscriptionAction(store.state.manageSubscriptionPageState)),
      onSubscriptionSelected: (package) => store.dispatch(SubscriptionSelectedAction(store.state.manageSubscriptionPageState, package)),
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
          onSubscriptionSelected == other.onSubscriptionSelected;
}
