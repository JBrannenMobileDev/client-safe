

import 'package:dandylight/models/ReminderDandyLight.dart';
import '../../models/JobType.dart';
import 'NewJobTypePageState.dart';

class LoadExistingJobTypeData{
  final NewJobTypePageState pageState;
  final JobType jobType;
  LoadExistingJobTypeData(this.pageState, this.jobType);
}

class LoadPricesPackagesAndRemindersAction {
  final NewJobTypePageState pageState;
  LoadPricesPackagesAndRemindersAction(this.pageState);
}

class SetAllAction {
  final NewJobTypePageState pageState;
  final List<ReminderDandyLight> allReminders;
  SetAllAction(this.pageState, this.allReminders);
}

class SaveNewJobTypeAction{
  final NewJobTypePageState pageState;
  SaveNewJobTypeAction(this.pageState);
}

class DeleteJobTypeAction{
  final NewJobTypePageState pageState;
  DeleteJobTypeAction(this.pageState);
}

class ClearNewJobTypeStateAction{
  final NewJobTypePageState pageState;
  ClearNewJobTypeStateAction(this.pageState);
}

class UpdateJobTypeTitleAction{
  final NewJobTypePageState pageState;
  final String title;
  UpdateJobTypeTitleAction(this.pageState, this.title);
}

class UpdateSelectedReminderListAction{
  final NewJobTypePageState pageState;
  final int reminderStageIndex;
  final bool isChecked;
  UpdateSelectedReminderListAction(this.pageState, this.reminderStageIndex, this.isChecked);
}

class SetSelectedStagesAction{
  final NewJobTypePageState pageState;
  final int jobStageIndex;
  final bool isChecked;
  SetSelectedStagesAction(this.pageState, this.jobStageIndex, this.isChecked);
}

class UpdateCheckAllTypesAction {
  final NewJobTypePageState pageState;
  final bool isChecked;
  UpdateCheckAllTypesAction(this.pageState, this.isChecked);
}

class UpdateCheckAllRemindersAction {
  final NewJobTypePageState pageState;
  final bool isChecked;
  UpdateCheckAllRemindersAction(this.pageState, this.isChecked);
}

class SaveSelectedRateTypeAction{
  final NewJobTypePageState pageState;
  final String rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}




