
import 'package:flutter_quill/flutter_quill.dart';

import '../../models/Contract.dart';
import 'ContractEditPageState.dart';

class SetContractAction{
  final ContractEditPageState pageState;
  final Contract contract;
  SetContractAction(this.pageState, this.contract);
}

class ClearContractEditState {
  final ContractEditPageState pageState;
  ClearContractEditState(this.pageState);
}

class SaveContractAction{
  final ContractEditPageState pageState;
  final Document quillContract;
  SaveContractAction(this.pageState, this.quillContract);
}

class SetContractNameAction {
  final ContractEditPageState pageState;
  final String contractName;
  SetContractNameAction(this.pageState, this.contractName);
}

class DeleteContractAction {
  final ContractEditPageState pageState;
  DeleteContractAction(this.pageState);
}

