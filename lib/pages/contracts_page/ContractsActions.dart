import 'package:dandylight/models/ReminderDandyLight.dart';

import 'ContractsPageState.dart';

class FetchRemindersAction{
  final ContractsPageState pageState;
  FetchRemindersAction(this.pageState);
}

class SetRemindersAction{
  final ContractsPageState pageState;
  final List<ReminderDandyLight> reminders;
  SetRemindersAction(this.pageState, this.reminders);
}

class DeleteReminderAction{
  final ContractsPageState pageState;
  final ReminderDandyLight reminder;
  DeleteReminderAction(this.pageState, this.reminder);
}

