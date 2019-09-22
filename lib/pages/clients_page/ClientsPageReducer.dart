import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'ClientsPageState.dart';

final clientsPageReducer = combineReducers<ClientsPageState>([
  new TypedReducer<ClientsPageState, InitHomePageAction>(_setupDataListeners),
]);

ClientsPageState _setupDataListeners(ClientsPageState previousState,
    InitHomePageAction action) {
  return ClientsPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}