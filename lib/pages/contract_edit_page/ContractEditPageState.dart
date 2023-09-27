import 'package:dandylight/models/Contract.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import 'ContractEditActions.dart';

class ContractEditPageState{
  final String contractName;
  final Contract contract;
  final Profile profile;
  final bool isNew;
  final Function(Document) onContractSaved;
  final Function() onDeleteSelected;
  final Function(String) onNameChanged;
  final Function() deleteFromJob;

  ContractEditPageState({
    @required this.contract,
    @required this.onContractSaved,
    @required this.contractName,
    @required this.onNameChanged,
    @required this.onDeleteSelected,
    @required this.profile,
    @required this.isNew,
    @required this.deleteFromJob,
  });

  ContractEditPageState copyWith({
    String contractName,
    Contract contract,
    Profile profile,
    bool isNew,
    Function(Document) onContractSaved,
    Function(String) onNameChanged,
    Function() onDeleteSelected,
    Function() deleteFromJob,
  }){
    return ContractEditPageState(
      contract: contract?? this.contract,
      onContractSaved: onContractSaved?? this.onContractSaved,
      contractName: contractName ?? this.contractName,
      onNameChanged: onNameChanged ?? this.onNameChanged,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      profile: profile ?? this.profile,
      isNew: isNew ?? this.isNew,
      deleteFromJob: deleteFromJob ?? this.deleteFromJob,
    );
  }

  factory ContractEditPageState.initial() => ContractEditPageState(
    contract: null,
    onContractSaved: null,
    contractName: '',
    onNameChanged: null,
    onDeleteSelected: null,
    profile: null,
    isNew: false,
    deleteFromJob: null,
  );

  factory ContractEditPageState.fromStore(Store<AppState> store) {
    return ContractEditPageState(
      contract: store.state.contractEditPageState.contract,
      contractName: store.state.contractEditPageState.contractName,
      profile: store.state.contractEditPageState.profile,
      isNew: store.state.contractEditPageState.isNew,
      deleteFromJob: store.state.contractEditPageState.deleteFromJob,
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
      profile.hashCode^
      isNew.hashCode ^
      deleteFromJob.hashCode ^
      onContractSaved.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractEditPageState &&
              contract == other.contract &&
              contractName == other.contractName &&
              onNameChanged == other.onNameChanged &&
              onDeleteSelected == other.onDeleteSelected &&
              profile == other.profile &&
              isNew == other.isNew &&
              deleteFromJob == other.deleteFromJob &&
              onContractSaved == other.onContractSaved;
}