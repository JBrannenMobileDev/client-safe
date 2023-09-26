import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart' as collectionReminder;

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class ContractsPageState{

  final List<Contract> contracts;
  final Function(Contract) onContractSelected;

  ContractsPageState({
    @required this.contracts,
    @required this.onContractSelected,
  });

  ContractsPageState copyWith({
    List<Contract> contracts,
    Function(Contract) onContractSelected,
  }){
    return ContractsPageState(
      contracts: contracts?? this.contracts,
      onContractSelected: onContractSelected?? this.onContractSelected,
    );
  }

  factory ContractsPageState.initial() => ContractsPageState(
    contracts: [],
    onContractSelected: null,
  );

  factory ContractsPageState.fromStore(Store<AppState> store) {
    return ContractsPageState(
      contracts: store.state.contractsPageState.contracts,
      // onContractSelected: (contract) => store.dispatch(LoadContractDataAction(store.state.newReminderPageState, contract)),
      onContractSelected: null,
    );
  }

  @override
  int get hashCode =>
      contracts.hashCode ^
      onContractSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractsPageState &&
              contracts == other.contracts &&
              onContractSelected == other.onContractSelected;
}