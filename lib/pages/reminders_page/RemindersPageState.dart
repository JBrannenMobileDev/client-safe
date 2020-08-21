import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart' as collectionReminder;

import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class RemindersPageState{

  final List<Reminder> reminders;
  final Function(Reminder) onReminderSelected;
  final Function(Reminder) onDeleteReminderSelected;

  RemindersPageState({
    @required this.reminders,
    @required this.onReminderSelected,
    @required this.onDeleteReminderSelected,
  });

  RemindersPageState copyWith({
    List<Reminder> reminders,
    Function(Reminder) onReminderSelected,
    Function(Reminder) onDeleteReminderSelected,
  }){
    return RemindersPageState(
      reminders: reminders?? this.reminders,
      onReminderSelected: onReminderSelected?? this.onReminderSelected,
      onDeleteReminderSelected: onDeleteReminderSelected?? this.onDeleteReminderSelected,
    );
  }

  factory RemindersPageState.initial() => RemindersPageState(
    reminders: List(),
    onReminderSelected: null,
    onDeleteReminderSelected: null,
  );

  factory RemindersPageState.fromStore(Store<AppState> store) {
    return RemindersPageState(
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
          other is RemindersPageState &&
              reminders == other.reminders &&
              onReminderSelected == other.onReminderSelected &&
              onDeleteReminderSelected == other.onDeleteReminderSelected;
}