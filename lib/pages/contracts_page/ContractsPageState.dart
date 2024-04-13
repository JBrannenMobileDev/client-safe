import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'ContractsActions.dart';

class ContractsPageState{
  final List<Contract>? contracts;
  final List<Contract>? contractTemplates;
  final Function(Contract, String)? onSaveToJobSelected;

  ContractsPageState({
    @required this.contracts,
    @required this.contractTemplates,
    @required this.onSaveToJobSelected,
  });

  ContractsPageState copyWith({
    List<Contract>? contracts,
    List<Contract>? contractTemplates,
    Function(Contract, String)? onSaveToJobSelected,
  }){
    return ContractsPageState(
      contracts: contracts?? this.contracts,
      contractTemplates: contractTemplates ?? this.contractTemplates,
      onSaveToJobSelected: onSaveToJobSelected ?? this.onSaveToJobSelected,
    );
  }

  factory ContractsPageState.initial() => ContractsPageState(
    contracts: [],
    contractTemplates: [],
    onSaveToJobSelected: null,
  );

  factory ContractsPageState.fromStore(Store<AppState> store) {
    return ContractsPageState(
      contracts: store.state.contractsPageState!.contracts,
      contractTemplates: store.state.contractsPageState!.contractTemplates,
      onSaveToJobSelected: (contract, jobDocumentId) => store.dispatch(SaveContractToJobAction(store.state.contractsPageState, contract, jobDocumentId)),
    );
  }

  @override
  int get hashCode =>
      contracts.hashCode ^
      onSaveToJobSelected.hashCode ^
      contractTemplates.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractsPageState &&
              contracts == other.contracts &&
              onSaveToJobSelected == other.onSaveToJobSelected &&
              contractTemplates == other.contractTemplates;
}