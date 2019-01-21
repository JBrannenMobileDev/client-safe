import 'package:client_safe/pages/home_page/HomePageState.dart';

class InitDashboardPageAction{
  final HomePageState item;
  InitDashboardPageAction(this.item);
}

class UpdateCurrentUserInfo{
  final String name;
  final String email;
  final int userColorId;
  final DashbaordPageState item;
  UpdateCurrentUserInfo(this.name, this.email, this.userColorId, this.item);
}

class DisposeDataListenersActions{
  final HomePageState item;
  DisposeDataListenersActions(this.item);
}
