import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/Profile.dart';

class SubscribeSelectedAction{
  final ManageSubscriptionPageState pageState;
  SubscribeSelectedAction(this.pageState);
}

class RestoreSubscriptionAction{
  final ManageSubscriptionPageState pageState;
  RestoreSubscriptionAction(this.pageState);
}

class SetManageSubscriptionStateAction{
  final ManageSubscriptionPageState pageState;
  final CustomerInfo subscriptionState;
  final double monthlyPrice;
  final double annualPrice;
  SetManageSubscriptionStateAction(this.pageState, this.subscriptionState, this.monthlyPrice, this.annualPrice);
}

class SetInitialDataAction{
  final ManageSubscriptionPageState pageState;
  final CustomerInfo subscriptionState;
  final Profile profile;
  SetInitialDataAction(this.pageState, this.subscriptionState, this.profile);
}

class FetchInitialDataAction{
  final ManageSubscriptionPageState pageState;
  final Profile profile;
  FetchInitialDataAction(this.pageState, this.profile);
}

class SubscriptionSelectedAction{
  final ManageSubscriptionPageState pageState;
  final Package package;
  SubscriptionSelectedAction(this.pageState, this.package);
}