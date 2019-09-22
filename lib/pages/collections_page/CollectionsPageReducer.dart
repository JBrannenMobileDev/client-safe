import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'CollectionsPageState.dart';

final collectionsPageReducer = combineReducers<CollectionsPageState>([
  new TypedReducer<CollectionsPageState, InitHomePageAction>(_setupDataListeners),
]);

CollectionsPageState _setupDataListeners(CollectionsPageState previousState,
    InitHomePageAction action) {
  return CollectionsPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}