
import 'package:redux/redux.dart';

import 'NewContractActions.dart';
import 'NewContractPageState.dart';

final newContractReducer = combineReducers<NewContractPageState>([
  TypedReducer<NewContractPageState, ClearStateAction>(_clearState),
  TypedReducer<NewContractPageState, UpdateContractName>(_updateContractName),
  TypedReducer<NewContractPageState, LoadExistingContractData>(_loadContractData),
  TypedReducer<NewContractPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewContractPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewContractPageState, SaveFilePathNewAction>(_setFilePath),
]);

NewContractPageState _setFilePath(NewContractPageState previousState, SaveFilePathNewAction action) {
  return previousState.copyWith(
    documentFilePath: action.filePath,
  );
}

NewContractPageState _incrementPageViewIndex(NewContractPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewContractPageState _decrementPageViewIndex(NewContractPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewContractPageState _clearState(NewContractPageState previousState, ClearStateAction action) {
  NewContractPageState newState = NewContractPageState.initial();
  return newState.copyWith(
    contractName: '',
    pageViewIndex: 0,
  );
}

NewContractPageState _updateContractName(NewContractPageState previousState, UpdateContractName action) {
  return previousState.copyWith(
    contractName: action.contractName,
  );
}

NewContractPageState _loadContractData(NewContractPageState previousState, LoadExistingContractData action){
  return previousState.copyWith(
    id: action.contract.id,
    documentId: action.contract.documentId,
    shouldClear: false,
    contractName: action.contract.contractName,
    pageViewIndex: 0,
  );
}
