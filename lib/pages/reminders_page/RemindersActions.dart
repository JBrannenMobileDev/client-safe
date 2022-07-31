import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';

class FetchRemindersAction{
  final RemindersPageState pageState;
  FetchRemindersAction(this.pageState);
}

class SetRemindersAction{
  final RemindersPageState pageState;
  final List<ReminderDandyLight> reminders;
  SetRemindersAction(this.pageState, this.reminders);
}

class DeleteReminderAction{
  final RemindersPageState pageState;
  final ReminderDandyLight reminder;
  DeleteReminderAction(this.pageState, this.reminder);
}

