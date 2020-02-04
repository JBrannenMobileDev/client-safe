import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';

class ClientSelectedAction{
  final ClientsPageState pageState;
  ClientSelectedAction(this.pageState);
}

class FilterChangedAction{
  final ClientsPageState pageState;
  final String filterType;
  FilterChangedAction(this.pageState, this.filterType);
}

class SetClientsData{
  final ClientsPageState pageState;
  final List<Client> clients;
  SetClientsData(this.pageState, this.clients);
}

class FetchClientData{
  final ClientsPageState pageState;
  FetchClientData(this.pageState);
}