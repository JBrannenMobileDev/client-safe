import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class ContractEditPageState{
  final bool hasUnsavedChanges;
  final Contract contract;
  final Function(Contract) onContractSelected;

  ContractEditPageState({
    @required this.contract,
    @required this.onContractSelected,
    @required this.hasUnsavedChanges,
  });

  ContractEditPageState copyWith({
    bool hasUnsavedChanges,
    Contract contract,
    Function(Contract) onContractSelected,
  }){
    return ContractEditPageState(
      contract: contract?? this.contract,
      onContractSelected: onContractSelected?? this.onContractSelected,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }

  factory ContractEditPageState.initial() => ContractEditPageState(
    contract: null,
    onContractSelected: null,
    hasUnsavedChanges: false,
  );

  factory ContractEditPageState.fromStore(Store<AppState> store) {
    return ContractEditPageState(
      hasUnsavedChanges: store.state.contractEditPageState.hasUnsavedChanges,
      contract: store.state.contractEditPageState.contract,
      // onContractSelected: (contract) => store.dispatch(LoadContractDataAction(store.state.newReminderPageState, contract)),
      onContractSelected: null,
    );
  }

  @override
  int get hashCode =>
      contract.hashCode ^
      hasUnsavedChanges.hashCode ^
      onContractSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractEditPageState &&
              contract == other.contract &&
              hasUnsavedChanges == other.hasUnsavedChanges &&
              onContractSelected == other.onContractSelected;
}