
import '../../models/Contract.dart';
import 'QuestionnairesPageState.dart';

class FetchContractsAction{
  final QuestionnairesPageState pageState;
  FetchContractsAction(this.pageState);
}

class SetContractsAction{
  final QuestionnairesPageState pageState;
  final List<Contract> contracts;
  final List<Contract> contractTemplates;
  SetContractsAction(this.pageState, this.contracts, this.contractTemplates);
}

class SaveContractToJobAction {
  final QuestionnairesPageState pageState;
  final Contract contract;
  final String jobDocumentId;
  SaveContractToJobAction(this.pageState, this.contract, this.jobDocumentId);
}

