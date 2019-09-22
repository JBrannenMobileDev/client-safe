import 'package:client_safe/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'MessagesPageState.dart';

final messagesPageReducer = combineReducers<MessagesPageState>([
  new TypedReducer<MessagesPageState, InitHomePageAction>(_setupDataListeners),
]);

MessagesPageState _setupDataListeners(MessagesPageState previousState,
    InitHomePageAction action) {
  return MessagesPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}