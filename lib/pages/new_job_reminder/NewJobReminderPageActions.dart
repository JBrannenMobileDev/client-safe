
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
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
  final Job job;
  SaveNewJobReminderAction(this.pageState, this.job);
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
  final ReminderDandyLight reminder;
  ReminderSelectedAction(this.pageState, this.reminder);
}

class SetAllRemindersAction{
  final NewJobReminderPageState pageState;
  final List<ReminderDandyLight> allReminders;
  SetAllRemindersAction(this.pageState, this.allReminders);
}

