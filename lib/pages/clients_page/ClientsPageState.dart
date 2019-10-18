import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class ClientsPageState {
  final String filterType;
  final Client selectedClient;
  final List<Client> all;
  final List<Client> clients;
  final List<Client> leads;
  final Function(String) onFilterChanged;
  final Function(Client) onClientClicked;
  final Function() fetchClientData;

  ClientsPageState({
    @required this.filterType,
    @required this.selectedClient,
    @required this.all,
    @required this.clients,
    @required this.leads,
    @required this.onFilterChanged,
    @required this.onClientClicked,
    @required this.fetchClientData,
  });

  ClientsPageState copyWith({
    String filterType,
    Client selectedClient,
    List<Client> all,
    List<Client> clients,
    List<Client> leads,
    Function(String) onFilterChanged,
    Function(String) onClientClicked,
    Function() fetchClientData,
  }){
    return ClientsPageState(
      filterType: filterType?? this.filterType,
      selectedClient: selectedClient?? this.selectedClient,
      all: all?? this.all,
      clients: clients?? this.clients,
      leads: leads?? this.leads,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onClientClicked: onClientClicked?? this.onClientClicked,
      fetchClientData: fetchClientData?? this.fetchClientData,
    );
  }

  factory ClientsPageState.initial() => ClientsPageState(
    filterType: ClientsPage.FILTER_TYPE_ALL,
    selectedClient: null,
    all: List(),
    clients: List(),
    leads: List(),
    onFilterChanged: null,
    onClientClicked: null,
    fetchClientData: null,
  );

  factory ClientsPageState.fromStore(Store<AppState> store) {
    return ClientsPageState(
      filterType: store.state.clientsPageState.filterType,
      selectedClient: store.state.clientsPageState.selectedClient,
      all: store.state.clientsPageState.all,
      clients: store.state.clientsPageState.clients,
      leads: store.state.clientsPageState.leads,
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.clientsPageState, filterType)),
      onClientClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
      fetchClientData: () => store.dispatch(FetchClientData(store.state.clientsPageState)),
    );
  }

  @override
  int get hashCode =>
    filterType.hashCode ^
    selectedClient.hashCode ^
    all.hashCode ^
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
          all == other.all &&
          clients == other.clients &&
          leads == other.leads &&
          onFilterChanged == other.onFilterChanged &&
          onClientClicked == other.onClientClicked;
}
