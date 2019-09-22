import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'SearchPageState.dart';

final searchPageReducer = combineReducers<SearchPageState>([
  new TypedReducer<SearchPageState, InitHomePageAction>(_setupDataListeners),
]);

SearchPageState _setupDataListeners(SearchPageState previousState,
    InitHomePageAction action) {
  return SearchPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}