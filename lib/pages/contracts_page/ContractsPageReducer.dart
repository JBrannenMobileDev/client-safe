import 'package:redux/redux.dart';
import 'ContractsActions.dart';
import 'ContractsPageState.dart';

final contractsReducer = combineReducers<ContractsPageState>([
  TypedReducer<ContractsPageState, SetContractsAction>(_setContracts),
]);

ContractsPageState _setContracts(ContractsPageState previousState, SetContractsAction action){
  return previousState.copyWith(
    contracts: action.contracts,
    contractTemplates: action.contractTemplates,
  );
}
