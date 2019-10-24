
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';

class UpdateErrorStateAction{
  final NewJobPageState pageState;
  final String errorCode;
  UpdateErrorStateAction(this.pageState, this.errorCode);
}

class ClearStateAction{
  final NewJobPageState pageState;
  ClearStateAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewJobPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewJobPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveNewJobAction{
  final NewJobPageState pageState;
  SaveNewJobAction(this.pageState);
}

class SetClientAction{
  final NewJobPageState pageState;
  final Client client;
  SetClientAction(this.pageState, this.client);
}

class FilterClientList{
  final NewJobPageState pageState;
  final String textInput;
  FilterClientList(this.pageState, this.textInput);
}

class ClearSearchInputActon{
  final NewJobPageState pageState;
  ClearSearchInputActon(this.pageState);
}

class FetchAllClientsAction{
  final NewJobPageState pageState;
  FetchAllClientsAction(this.pageState);
}

class SetAllClientsToStateAction{
  final NewJobPageState pageState;
  final List<Client> allClients;
  SetAllClientsToStateAction(this.pageState, this.allClients);
}
