import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:redux/redux.dart';

import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  new TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
  new TypedReducer<DashboardPageState, SetJobToStateAction>(_setJobs),
  new TypedReducer<DashboardPageState, SetClientsDashboardAction>(_setClients),
]);

DashboardPageState _setupDataListeners(DashboardPageState previousState, InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}

DashboardPageState _setJobs(DashboardPageState previousState, SetJobToStateAction action) {
  return previousState.copyWith(
      currentJobs: action.upcomingJobs
  );
}

DashboardPageState _setClients(DashboardPageState previousState, SetClientsDashboardAction action) {
  List<Client> leads = List();

  for(Client client in action.clients){
    bool clientHasJob = false;
    for(Job job in previousState.currentJobs) {
      if(client.id == job.clientId) clientHasJob = true;
    }
    if(!clientHasJob){
      leads.add(client);
    }
  }

  return previousState.copyWith(
      recentLeads: leads);
}