
import '../../models/Contract.dart';
import 'ContractsPageState.dart';

class FetchContractsAction{
  final ContractsPageState pageState;
  FetchContractsAction(this.pageState);
}

class SetContractsAction{
  final ContractsPageState pageState;
  final List<Contract> contracts;
  final List<Contract> contractTemplates;
  SetContractsAction(this.pageState, this.contracts, this.contractTemplates);
}

class SaveContractToJobAction {
  final ContractsPageState pageState;
  final Contract contract;
  final String jobDocumentId;
  SaveContractToJobAction(this.pageState, this.contract, this.jobDocumentId);
}

