import 'package:client_safe/pages/home_page/HomePageState.dart';

class InitHomePageAction{
  final HomePageState item;
  InitHomePageAction(this.item);
}

class UpdateCurrentUserInfo{
  final String name;
  final String email;
  final int userColorId;
  final HomePageState item;
  UpdateCurrentUserInfo(this.name, this.email, this.userColorId, this.item);
}

class DisposeDataListenersActions{
  final HomePageState item;
  DisposeDataListenersActions(this.item);
}
