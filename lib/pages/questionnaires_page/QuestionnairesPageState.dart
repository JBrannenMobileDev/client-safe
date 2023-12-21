import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageState{
  final List<Contract> contracts;
  final List<Contract> contractTemplates;
  final Function(Contract, String) onSaveToJobSelected;

  QuestionnairesPageState({
    @required this.contracts,
    @required this.contractTemplates,
    @required this.onSaveToJobSelected,
  });

  QuestionnairesPageState copyWith({
    List<Contract> contracts,
    List<Contract> contractTemplates,
    Function(Contract, String) onSaveToJobSelected,
  }){
    return QuestionnairesPageState(
      contracts: contracts?? this.contracts,
      contractTemplates: contractTemplates ?? this.contractTemplates,
      onSaveToJobSelected: onSaveToJobSelected ?? this.onSaveToJobSelected,
    );
  }

  factory QuestionnairesPageState.initial() => QuestionnairesPageState(
    contracts: [],
    contractTemplates: [],
    onSaveToJobSelected: null,
  );

  factory QuestionnairesPageState.fromStore(Store<AppState> store) {
    return QuestionnairesPageState(
      contracts: store.state.contractsPageState.contracts,
      contractTemplates: store.state.contractsPageState.contractTemplates,
      onSaveToJobSelected: (contract, jobDocumentId) => store.dispatch(SaveContractToJobAction(store.state.questionnairesPageState, contract, jobDocumentId)),
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
          other is QuestionnairesPageState &&
              contracts == other.contracts &&
              onSaveToJobSelected == other.onSaveToJobSelected &&
              contractTemplates == other.contractTemplates;
}