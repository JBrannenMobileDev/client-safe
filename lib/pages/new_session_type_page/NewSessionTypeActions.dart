

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

class LoadAllRemindersAction {
  final NewSessionTypePageState? pageState;
  LoadAllRemindersAction(this.pageState);
}

class SetAllAction {
  final NewSessionTypePageState? pageState;
  final List<ReminderDandyLight>? allReminders;
  SetAllAction(this.pageState, this.allReminders);
}

class SaveNewSessionTypeAction{
  final NewSessionTypePageState? pageState;
  SaveNewSessionTypeAction(this.pageState);
}

class DeleteSessionTypeAction{
  final NewSessionTypePageState? pageState;
  DeleteSessionTypeAction(this.pageState);
}

class ClearNewSessionTypeStateAction{
  final NewSessionTypePageState? pageState;
  ClearNewSessionTypeStateAction(this.pageState);
}

class UpdateJobSessionTypeNameAction{
  final NewSessionTypePageState? pageState;
  final String? title;
  UpdateJobSessionTypeNameAction(this.pageState, this.title);
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

class SetStageSelectionCompleteAction {
  final NewSessionTypePageState? pageState;
  final bool? complete;
  SetStageSelectionCompleteAction(this.pageState, this.complete);
}

class SetRemindersSelectionCompleteAction {
  final NewSessionTypePageState? pageState;
  final bool? complete;
  SetRemindersSelectionCompleteAction(this.pageState, this.complete);
}



