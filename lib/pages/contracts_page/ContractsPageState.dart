import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class ContractsPageState{
  final List<Contract> contracts;
  final List<Contract> contractTemplates;

  ContractsPageState({
    @required this.contracts,
    @required this.contractTemplates,
  });

  ContractsPageState copyWith({
    List<Contract> contracts,
    List<Contract> contractTemplates,
    Function(Contract) onContractSelected,
  }){
    return ContractsPageState(
      contracts: contracts?? this.contracts,
      contractTemplates: contractTemplates ?? this.contractTemplates,
    );
  }

  factory ContractsPageState.initial() => ContractsPageState(
    contracts: [],
    contractTemplates: [],
  );

  factory ContractsPageState.fromStore(Store<AppState> store) {
    return ContractsPageState(
      contracts: store.state.contractsPageState.contracts,
      contractTemplates: store.state.contractsPageState.contractTemplates,
    );
  }

  @override
  int get hashCode =>
      contracts.hashCode ^
      contractTemplates.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractsPageState &&
              contracts == other.contracts &&
              contractTemplates == other.contractTemplates;
}