
import '../../models/Contract.dart';
import 'ContractEditPageState.dart';

class SetContractAction{
  final ContractEditPageState pageState;
  final Contract contract;
  SetContractAction(this.pageState, this.contract);
}

class SaveContractAction{
  final ContractEditPageState pageState;
  SaveContractAction(this.pageState);
}

