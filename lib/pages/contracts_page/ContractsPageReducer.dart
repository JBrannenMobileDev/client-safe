import 'package:dandylight/pages/contracts_page/ContractsActions.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageState.dart';
import 'package:redux/redux.dart';

final contractsReducer = combineReducers<ContractsPageState>([
  TypedReducer<ContractsPageState, SetContractsAction>(_setContracts),
]);

ContractsPageState _setContracts(ContractsPageState previousState, SetContractsAction action){
  return previousState.copyWith(
    contracts: action.contracts
  );
}
