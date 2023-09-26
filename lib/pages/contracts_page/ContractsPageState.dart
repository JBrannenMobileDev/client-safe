import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart' as collectionReminder;

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class ContractsPageState{

  final List<ReminderDandyLight> reminders;
  final Function(ReminderDandyLight) onReminderSelected;
  final Function(ReminderDandyLight) onDeleteReminderSelected;

  ContractsPageState({
    @required this.reminders,
    @required this.onReminderSelected,
    @required this.onDeleteReminderSelected,
  });

  ContractsPageState copyWith({
    List<ReminderDandyLight> reminders,
    Function(ReminderDandyLight) onReminderSelected,
    Function(ReminderDandyLight) onDeleteReminderSelected,
  }){
    return ContractsPageState(
      reminders: reminders?? this.reminders,
      onReminderSelected: onReminderSelected?? this.onReminderSelected,
      onDeleteReminderSelected: onDeleteReminderSelected?? this.onDeleteReminderSelected,
    );
  }

  factory ContractsPageState.initial() => ContractsPageState(
    reminders: List(),
    onReminderSelected: null,
    onDeleteReminderSelected: null,
  );

  factory ContractsPageState.fromStore(Store<AppState> store) {
    return ContractsPageState(
      reminders: store.state.remindersPageState.reminders,
      onReminderSelected: (reminder) => store.dispatch(LoadExistingReminderData(store.state.newReminderPageState, reminder)),
      onDeleteReminderSelected: (reminder) => store.dispatch(collectionReminder.DeleteReminderAction(store.state.remindersPageState, reminder)),
    );
  }

  @override
  int get hashCode =>
      reminders.hashCode ^
      onReminderSelected.hashCode ^
      onDeleteReminderSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ContractsPageState &&
              reminders == other.reminders &&
              onReminderSelected == other.onReminderSelected &&
              onDeleteReminderSelected == other.onDeleteReminderSelected;
}