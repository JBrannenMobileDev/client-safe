import 'package:redux/redux.dart';

import 'DashboardPageActions.dart';
import 'DashboardPageState.dart';

final dashboardPageReducer = combineReducers<DashboardPageState>([
  new TypedReducer<DashboardPageState, InitDashboardPageAction>(_setupDataListeners),
]);

DashboardPageState _setupDataListeners(DashboardPageState previousState,
    InitDashboardPageAction action) {
  return previousState.copyWith(jobsProfitTotal: "\$50");
}