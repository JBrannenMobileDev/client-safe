import 'package:redux/redux.dart';
import 'ContractEditActions.dart';
import 'ContractEditPageState.dart';

final contractEditReducer = combineReducers<ContractEditPageState>([
  TypedReducer<ContractEditPageState, SetContractAction>(_setContracts),
]);

ContractEditPageState _setContracts(ContractEditPageState previousState, SetContractAction action){
  return previousState.copyWith(
    contract: action.contract
  );
}
