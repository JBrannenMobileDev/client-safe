import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';

class FetchRemindersAction{
  final RemindersPageState pageState;
  FetchRemindersAction(this.pageState);
}

class SetRemindersAction{
  final RemindersPageState pageState;
  final List<Reminder> reminders;
  SetRemindersAction(this.pageState, this.reminders);
}

class DeleteReminderAction{
  final RemindersPageState pageState;
  final Reminder reminder;
  DeleteReminderAction(this.pageState, this.reminder);
}

