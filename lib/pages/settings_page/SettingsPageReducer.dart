import 'package:dandylight/pages/home_page/HomePageActions.dart';
import 'package:redux/redux.dart';
import 'SettingsPageState.dart';

final settingsPageReducer = combineReducers<SettingsPageState>([
  new TypedReducer<SettingsPageState, InitHomePageAction>(_setupDataListeners),
]);

SettingsPageState _setupDataListeners(SettingsPageState previousState,
    InitHomePageAction action) {
  return SettingsPageState(
    previousState.accountName,
    previousState.actionItems,
    previousState.recentClients,
    previousState.onAddNewClientClicked,
    previousState.onSearchClientsClicked,
    previousState.onActionItemClicked,
    previousState.onClientClicked
  );
}