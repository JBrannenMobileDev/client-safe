import 'package:dandylight/pages/home_page/HomePageActions.dart';
import 'package:dandylight/pages/home_page/HomePageState.dart';
import 'package:redux/redux.dart';

final homePageReducer = combineReducers<HomePageState>([
  new TypedReducer<HomePageState, InitHomePageAction>(_setupDataListeners),
  new TypedReducer<HomePageState, DisposeDataListenersActions>(_disposeDataListeners),
  new TypedReducer<HomePageState, UpdateCurrentUserInfo>(_updateCurrentUserInfo),
]);

HomePageState _setupDataListeners(HomePageState previousState,
    InitHomePageAction action) {
  return HomePageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}

HomePageState _updateCurrentUserInfo(HomePageState previousState,
    UpdateCurrentUserInfo action) {
  return HomePageState(
      previousState.accountName,
      previousState.actionItems,
      previousState.recentClients,
      previousState.onAddNewClientClicked,
      previousState.onSearchClientsClicked,
      previousState.onActionItemClicked,
      previousState.onClientClicked
  );
}

HomePageState _disposeDataListeners(HomePageState previousState, DisposeDataListenersActions action) {
  return HomePageState(
      previousState.accountName,
      previousState.actionItems,
      previousState.recentClients,
      previousState.onAddNewClientClicked,
      previousState.onSearchClientsClicked,
      previousState.onActionItemClicked,
      previousState.onClientClicked
  );
}
