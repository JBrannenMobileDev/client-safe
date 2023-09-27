
import 'package:flutter_quill/flutter_quill.dart';

import '../../models/Contract.dart';
import '../../models/Profile.dart';
import 'ContractEditPageState.dart';

class SetContractAction{
  final ContractEditPageState pageState;
  final Contract contract;
  SetContractAction(this.pageState, this.contract);
}

class ClearContractEditState {
  final ContractEditPageState pageState;
  final bool isNew;
  ClearContractEditState(this.pageState, this.isNew);
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

class FetchProfileForContractEditAction {
  final ContractEditPageState pageState;
  FetchProfileForContractEditAction(this.pageState);
}

class SetProfileForContractEditAction {
  final ContractEditPageState pageState;
  final Profile profile;
  SetProfileForContractEditAction(this.pageState, this.profile);
}

