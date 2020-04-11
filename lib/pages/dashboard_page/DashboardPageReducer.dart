import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:redux/redux.dart';

import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
  TypedReducer<DashboardPageState, SetJobToStateAction>(_setJobs),
  TypedReducer<DashboardPageState, SetClientsDashboardAction>(_setClients),
  TypedReducer<DashboardPageState, UpdateShowHideState>(_updateShowHideState),
]);

DashboardPageState _setupDataListeners(DashboardPageState previousState, InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}

DashboardPageState _updateShowHideState(DashboardPageState previousState, UpdateShowHideState action) {
  return previousState.copyWith(
      isMinimized: !previousState.isMinimized,
  );
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
    for(Job job in previousState.upcomingJobs) {
      if(client.id == job.clientId) clientHasJob = true;
    }
    if(!clientHasJob){
      leads.add(client);
    }
  }

  return previousState.copyWith(
      recentLeads: leads);
}