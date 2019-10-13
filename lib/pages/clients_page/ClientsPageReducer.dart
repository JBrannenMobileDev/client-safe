import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:redux/redux.dart';
import 'ClientsPageState.dart';

final clientsPageReducer = combineReducers<ClientsPageState>([
  TypedReducer<ClientsPageState, SetClientsData>(_setClientData),
  TypedReducer<ClientsPageState, FilterChangedAction>(_updateFilterSelection),
]);

ClientsPageState _setClientData(ClientsPageState previousState, SetClientsData action){
  List<Client> _clients = action.clients.where((client) => (client.jobs?.length ?? 0) > 0).toList();
  List<Client> _leads = action.clients.where((client) => (client.jobs?.length ?? 0) == 0).toList();
  _clients.sort((client1, client2) => client1.firstName.compareTo(client2.firstName));
  _leads.sort((client1, client2) => client1.firstName.compareTo(client2.firstName));
  action.clients.sort((client1, client2) => client1.firstName.compareTo(client2.firstName));
  return previousState.copyWith(
      clients: _clients,
      leads: _leads,
      all: action.clients
  );
}

ClientsPageState _updateFilterSelection(ClientsPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}