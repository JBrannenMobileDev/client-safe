import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
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

class LoadJobsAction{
  final DashboardPageState pageState;
  LoadJobsAction(this.pageState);
}

class SetJobToStateAction{
  final DashboardPageState pageState;
  final List<Job> upcomingJobs;
  SetJobToStateAction(this.pageState, this.upcomingJobs);
}

class SetClientsDashboardAction{
  final DashboardPageState pageState;
  final List<Client> clients;
  SetClientsDashboardAction(this.pageState, this.clients);
}
