

import 'package:dandylight/models/ReminderDandyLight.dart';
import '../../models/JobStage.dart';
import '../../models/JobType.dart';
import '../../models/SessionType.dart';
import 'NewSessionTypePageState.dart';

class LoadExistingSessionTypeData{
  final NewSessionTypePageState? pageState;
  final SessionType? sessionType;
  LoadExistingSessionTypeData(this.pageState, this.sessionType);
}

class LoadPricesPackagesAndRemindersAction {
  final NewSessionTypePageState? pageState;
  LoadPricesPackagesAndRemindersAction(this.pageState);
}

class SetAllAction {
  final NewSessionTypePageState? pageState;
  final List<ReminderDandyLight>? allReminders;
  SetAllAction(this.pageState, this.allReminders);
}

class SaveNewJobTypeAction{
  final NewSessionTypePageState? pageState;
  SaveNewJobTypeAction(this.pageState);
}

class DeleteJobTypeAction{
  final NewSessionTypePageState? pageState;
  DeleteJobTypeAction(this.pageState);
}

class ClearNewJobTypeStateAction{
  final NewSessionTypePageState? pageState;
  ClearNewJobTypeStateAction(this.pageState);
}

class UpdateJobTypeTitleAction{
  final NewSessionTypePageState? pageState;
  final String? title;
  UpdateJobTypeTitleAction(this.pageState, this.title);
}

class UpdateSelectedReminderListAction{
  final NewSessionTypePageState? pageState;
  final int? reminderStageIndex;
  final bool? isChecked;
  UpdateSelectedReminderListAction(this.pageState, this.reminderStageIndex, this.isChecked);
}

class DeleteJobStageAction{
  final NewSessionTypePageState? pageState;
  final int? jobStageIndex;
  DeleteJobStageAction(this.pageState, this.jobStageIndex);
}

class UpdateCheckAllRemindersAction {
  final NewSessionTypePageState? pageState;
  final bool? isChecked;
  UpdateCheckAllRemindersAction(this.pageState, this.isChecked);
}

class SaveSelectedRateTypeAction{
  final NewSessionTypePageState? pageState;
  final String? rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}

class UpdateStageListAction{
  final NewSessionTypePageState? pageState;
  final List<JobStage>? stages;
  UpdateStageListAction(this.pageState, this.stages);
}

class SetCustomStageNameAction{
  final NewSessionTypePageState? pageState;
  final String? stageName;
  SetCustomStageNameAction(this.pageState, this.stageName);
}

class SaveNewStageAction{
  final NewSessionTypePageState? pageState;
  SaveNewStageAction(this.pageState);
}

class UpdateTotalCostTextAction{
  final NewSessionTypePageState? pageState;
  final String? flatRateText;
  UpdateTotalCostTextAction(this.pageState, this.flatRateText);
}

class UpdateDepositAmountAction{
  final NewSessionTypePageState? pageState;
  final String? depositAmount;
  UpdateDepositAmountAction(this.pageState, this.depositAmount);
}

class UpdateTaxPercentAction {
  final NewSessionTypePageState? pageState;
  final String? taxPercent;
  UpdateTaxPercentAction(this.pageState, this.taxPercent);
}

class UpdateMinutesAction {
  final NewSessionTypePageState? pageState;
  final String? minutes;
  UpdateMinutesAction(this.pageState, this.minutes);
}

class UpdateHoursAction {
  final NewSessionTypePageState? pageState;
  final String? hours;
  UpdateHoursAction(this.pageState, this.hours);
}



