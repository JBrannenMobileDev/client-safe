
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';

class SetSelectedTimeAction{
  final NewJobReminderPageState pageState;
  final DateTime time;
  SetSelectedTimeAction(this.pageState, this.time);
}

class FetchAllRemindersAction{
  final NewJobReminderPageState pageState;
  FetchAllRemindersAction(this.pageState);
}

class SaveNewJobReminderAction{
  final NewJobReminderPageState pageState;
  SaveNewJobReminderAction(this.pageState);
}

class ClearNewJobReminderStateAction{
  final NewJobReminderPageState pageState;
  ClearNewJobReminderStateAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewJobReminderPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewJobReminderPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class ReminderSelectedAction{
  final NewJobReminderPageState pageState;
  final Reminder reminder;
  ReminderSelectedAction(this.pageState, this.reminder);
}

class SetAllRemindersAction{
  final NewJobReminderPageState pageState;
  final List<Reminder> allReminders;
  SetAllRemindersAction(this.pageState, this.allReminders);
}

