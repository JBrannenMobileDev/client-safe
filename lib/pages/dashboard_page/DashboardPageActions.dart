import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';


class InitDashboardPageAction{
  final DashboardPageState item;
  InitDashboardPageAction(this.item);
}

class DisposeDataListenersActions{
  final HomePageState item;
  DisposeDataListenersActions(this.item);
}
