import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:redux/redux.dart';
import 'NewJobPageState.dart';

final newJobPageReducer = combineReducers<NewJobPageState>([
  TypedReducer<NewJobPageState, ClearStateAction>(_clearState),
  TypedReducer<NewJobPageState, IncrementPageViewIndex>(
      _incrementPageViewIndex),
  TypedReducer<NewJobPageState, DecrementPageViewIndex>(
      _decrementPageViewIndex),
  TypedReducer<NewJobPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewJobPageState, SetAllClientsToStateAction>(_setAllClients),
  TypedReducer<NewJobPageState, ClientSelectedAction>(_setSelectedClient),
  TypedReducer<NewJobPageState, FilterClientList>(_filterClients),
]);

NewJobPageState _updateErrorState(
    NewJobPageState previousState, UpdateErrorStateAction action) {
  return previousState.copyWith(errorState: action.errorCode);
}

NewJobPageState _incrementPageViewIndex(
    NewJobPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(pageViewIndex: incrementedIndex);
}

NewJobPageState _decrementPageViewIndex(
    NewJobPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(pageViewIndex: decrementedIndex);
}

NewJobPageState _clearState(
    NewJobPageState previousState, ClearStateAction action) {
  return NewJobPageState.initial();
}

NewJobPageState _setAllClients(
    NewJobPageState previousState, SetAllClientsToStateAction action) {
  return previousState.copyWith(
    allClients: action.allClients,
    filteredClients: action.allClients,
    isFinishedFetchingClients: true,
  );
}

NewJobPageState _setSelectedClient(
    NewJobPageState previousState, ClientSelectedAction action) {
  Client selectedClient =
      previousState.selectedClient == action.client ? null : action.client;
  return previousState.copyWith(
    selectedClient: selectedClient,
  );
}

NewJobPageState _filterClients(NewJobPageState previousState, FilterClientList action) {
  List<Client> filteredClients = action.textInput.length > 0
      ? previousState.allClients
          .where((client) => client
              .getClientFullName()
              .toLowerCase()
              .contains(action.textInput.toLowerCase()))
          .toList()
      : previousState.allClients;
  return previousState.copyWith(
    filteredClients: filteredClients,
  );
}
