

import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';

class LoadExistingReminderData{
  final NewReminderPageState pageState;
  final Reminder reminder;
  LoadExistingReminderData(this.pageState, this.reminder);
}

class SaveNewReminderAction{
  final NewReminderPageState pageState;
  SaveNewReminderAction(this.pageState);
}

class DeleteReminderAction{
  final NewReminderPageState pageState;
  DeleteReminderAction(this.pageState);
}

class ClearNewReminderStateAction{
  final NewReminderPageState pageState;
  ClearNewReminderStateAction(this.pageState);
}

class UpdateWhenAction{
  final NewReminderPageState pageState;
  final String when;
  UpdateWhenAction(this.pageState, this.when);
}

class UpdateDescription{
  final NewReminderPageState pageState;
  final String description;
  UpdateDescription(this.pageState, this.description);
}

class UpdateDaysWeeksMonthsAction{
  final NewReminderPageState pageState;
  final String daysWeeksMonthsSelection;
  UpdateDaysWeeksMonthsAction(this.pageState, this.daysWeeksMonthsSelection);
}

class UpdateDaysWeeksMonthsAmountAction{
  final NewReminderPageState pageState;
  final int amount;
  UpdateDaysWeeksMonthsAmountAction(this.pageState, this.amount);
}

class SetSelectedTimeAction{
  final NewReminderPageState pageState;
  final DateTime time;
  SetSelectedTimeAction(this.pageState, this.time);
}

class SetIsDefaultAction{
  final NewReminderPageState pageState;
  final bool isDefault;
  SetIsDefaultAction(this.pageState, this.isDefault);
}





