import 'package:redux/redux.dart';
import 'ContractEditActions.dart';
import 'ContractEditPageState.dart';

final contractEditReducer = combineReducers<ContractEditPageState>([
  TypedReducer<ContractEditPageState, SetContractAction>(_setContracts),
  TypedReducer<ContractEditPageState, SetContractNameAction>(_setContractName),
  TypedReducer<ContractEditPageState, ClearContractEditState>(_clearState),
  TypedReducer<ContractEditPageState, SetProfileForContractEditAction>(_setProfile),
]);

ContractEditPageState _setProfile(ContractEditPageState previousState, SetProfileForContractEditAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

ContractEditPageState _clearState(ContractEditPageState previousState, ClearContractEditState action){
  ContractEditPageState pageState = ContractEditPageState.initial();
  return pageState.copyWith(
    isNew: action.isNew,
    newFromName: action.contractName,
  );
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
