import 'package:redux/redux.dart';
import 'ContractEditActions.dart';
import 'ContractEditPageState.dart';

final contractEditReducer = combineReducers<ContractEditPageState>([
  TypedReducer<ContractEditPageState, SetContractAction>(_setContracts),
  TypedReducer<ContractEditPageState, SetContractNameAction>(_setContractName),
  TypedReducer<ContractEditPageState, ClearContractEditState>(_clearState),
]);

ContractEditPageState _clearState(ContractEditPageState previousState, ClearContractEditState action){
  return ContractEditPageState.initial();
}

ContractEditPageState _setContractName(ContractEditPageState previousState, SetContractNameAction action){
  return previousState.copyWith(
      contractName: action.contractName,
  );
}

ContractEditPageState _setContracts(ContractEditPageState previousState, SetContractAction action){
  return previousState.copyWith(
    contract: action.contract
  );
}
