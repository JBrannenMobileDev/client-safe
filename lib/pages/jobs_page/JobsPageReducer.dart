import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'JobsPageState.dart';

final jobsPageReducer = combineReducers<JobsPageState>([
  new TypedReducer<JobsPageState, InitHomePageAction>(_setupDataListeners),
]);

JobsPageState _setupDataListeners(JobsPageState previousState,
    InitHomePageAction action) {
  return JobsPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}