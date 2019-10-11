import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class ClientsPageState {
  final String filterType;
  final Client selectedClient;
  final List<Client> clients;
  final List<Client> leads;
  final Function(String) onFilterChanged;
  final Function(Client) onClientClicked;

  ClientsPageState({
    @required this.filterType,
    @required this.selectedClient,
    @required this.clients,
    @required this.leads,
    @required this.onFilterChanged,
    @required this.onClientClicked,
  });

  ClientsPageState copyWith({
    String filterType,
    Client selectedClient,
    List<Client> clients,
    List<Client> leads,
    Function(String) onFilterChanged,
    Function(String) onClientClicked,
  }){
    return ClientsPageState(
      filterType: filterType?? this.filterType,
      selectedClient: selectedClient?? this.selectedClient,
      clients: clients?? this.clients,
      leads: leads?? this.leads,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onClientClicked: onClientClicked?? this.onClientClicked,
    );
  }

  factory ClientsPageState.initial() => ClientsPageState(
    filterType: "Leads",
    selectedClient: null,
    clients: List(),
    leads: List(),
    onFilterChanged: null,
    onClientClicked: null,
  );

  factory ClientsPageState.fromStore(Store<AppState> store) {
    return ClientsPageState(
      filterType: store.state.clientsPageState.filterType,
      selectedClient: store.state.clientsPageState.selectedClient,
      clients: store.state.clientsPageState.clients,
      leads: store.state.clientsPageState.leads,
      onFilterChanged: (filterType) => store.dispatch(null),
      onClientClicked: (client) => store.dispatch(null),
    );
  }

  @override
  int get hashCode =>
    filterType.hashCode ^
    selectedClient.hashCode ^
    clients.hashCode ^
    leads.hashCode ^
    onFilterChanged.hashCode ^
    onClientClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientsPageState &&
          filterType == other.filterType &&
          selectedClient == other.selectedClient &&
          clients == other.clients &&
          leads == other.leads &&
          onFilterChanged == other.onFilterChanged &&
          onClientClicked == other.onClientClicked;
}
