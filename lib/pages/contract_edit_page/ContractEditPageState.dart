import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'ContractEditActions.dart';

class ContractEditPageState{
  final String contractName;
  final Contract contract;
  final Function(Document) onContractSaved;
  final Function() onDeleteSelected;
  final Function(String) onNameChanged;

  ContractEditPageState({
    @required this.contract,
    @required this.onContractSaved,
    @required this.contractName,
    @required this.onNameChanged,
    @required this.onDeleteSelected,
  });

  ContractEditPageState copyWith({
    String contractName,
    Contract contract,
    Function(Document) onContractSaved,
    Function(String) onNameChanged,
    Function() onDeleteSelected,
  }){
    return ContractEditPageState(
      contract: contract?? this.contract,
      onContractSaved: onContractSaved?? this.onContractSaved,
      contractName: contractName ?? this.contractName,
      onNameChanged: onNameChanged ?? this.onNameChanged,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
    );
  }

  factory ContractEditPageState.initial() => ContractEditPageState(
    contract: null,
    onContractSaved: null,
    contractName: '',
    onNameChanged: null,
    onDeleteSelected: null,
  );

  factory ContractEditPageState.fromStore(Store<AppState> store) {
    return ContractEditPageState(
      contract: store.state.contractEditPageState.contract,
      contractName: store.state.contractEditPageState.contractName,
      onContractSaved: (contract) => store.dispatch(SaveContractAction(store.state.contractEditPageState, contract)),
      onNameChanged: (contractName) => store.dispatch(SetContractNameAction(store.state.contractEditPageState, contractName)),
      onDeleteSelected: () => store.dispatch(DeleteContractAction(store.state.contractEditPageState)),
    );
  }

  @override
  int get hashCode =>
      contract.hashCode ^
      contractName.hashCode ^
      onNameChanged.hashCode ^
      onDeleteSelected.hashCode ^
      onContractSaved.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractEditPageState &&
              contract == other.contract &&
              contractName == other.contractName &&
              onNameChanged == other.onNameChanged &&
              onDeleteSelected == other.onDeleteSelected &&
              onContractSaved == other.onContractSaved;
}