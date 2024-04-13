import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/clients_page/ClientsPageState.dart';

class ClientSelectedAction{
  final ClientsPageState? pageState;
  ClientSelectedAction(this.pageState);
}

class FilterChangedAction{
  final ClientsPageState? pageState;
  final String? filterType;
  FilterChangedAction(this.pageState, this.filterType);
}

class SetClientsData{
  final ClientsPageState? pageState;
  final List<Client>? clients;
  final List<Job>? allJobs;
  SetClientsData(this.pageState, this.clients, this.allJobs);
}

class FetchClientData{
  final ClientsPageState? pageState;
  FetchClientData(this.pageState);
}