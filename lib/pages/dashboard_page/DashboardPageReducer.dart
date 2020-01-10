import 'package:redux/redux.dart';

import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  new TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
  new TypedReducer<DashboardPageState, SetJobToStateAction>(_setJobs),
]);

DashboardPageState _setupDataListeners(DashboardPageState previousState, InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}

DashboardPageState _setJobs(DashboardPageState previousState, SetJobToStateAction action) {
  return previousState.copyWith(currentJobs: action.upcomingJobs);
}