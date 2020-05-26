import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/utils/JobUtil.dart';
import 'package:redux/redux.dart';

import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
  TypedReducer<DashboardPageState, SetJobToStateAction>(_setJobs),
  TypedReducer<DashboardPageState, SetClientsDashboardAction>(_setClients),
  TypedReducer<DashboardPageState, UpdateShowHideState>(_updateShowHideState),
  TypedReducer<DashboardPageState, UpdateShowHideLeadsState>(_updateShowHideLeadsState),
]);

DashboardPageState _setupDataListeners(DashboardPageState previousState, InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}

DashboardPageState _updateShowHideState(DashboardPageState previousState, UpdateShowHideState action) {
  return previousState.copyWith(
      isMinimized: !previousState.isMinimized,
  );
}

DashboardPageState _updateShowHideLeadsState(DashboardPageState previousState, UpdateShowHideLeadsState action) {
  return previousState.copyWith(
    isLeadsMinimized: !previousState.isLeadsMinimized,
  );
}

DashboardPageState _setJobs(DashboardPageState previousState, SetJobToStateAction action) {
  return previousState.copyWith(
      currentJobs: JobUtil.getUpComingJobs(action.allJobs),
      allJobs: action.allJobs,
  );
}

DashboardPageState _setClients(DashboardPageState previousState, SetClientsDashboardAction action) {
  List<Client> leads = action.clients.where((client) => (!_hasAJob(client.id, previousState.allJobs))).toList();
  return previousState.copyWith(
      recentLeads: leads.reversed.toList());
}

bool _hasAJob(int clientId, List<Job> jobs) {
  List<Job> clientJobs = jobs.where((job) => job.clientId == clientId).toList();
  if(clientJobs.length > 0) return true;
  return false;
}