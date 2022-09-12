import 'package:dandylight/models/Contract.dart';

import 'NewContractPageState.dart';


class LoadExistingContractData{
  final NewContractPageState pageState;
  final Contract contract;
  LoadExistingContractData(this.pageState, this.contract);
}

class SaveContractAction{
  final NewContractPageState pageState;
  SaveContractAction(this.pageState);
}

class ClearStateAction{
  final NewContractPageState pageState;
  ClearStateAction(this.pageState);
}

class DeleteContract{
  final NewContractPageState pageState;
  DeleteContract(this.pageState);
}

class UpdateContractName{
  final NewContractPageState pageState;
  final String contractName;
  UpdateContractName(this.pageState, this.contractName);
}

class IncrementPageViewIndex{
  final NewContractPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewContractPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveFilePathNewAction{
  final NewContractPageState pageState;
  final String filePath;
  SaveFilePathNewAction(this.pageState, this.filePath);
}

