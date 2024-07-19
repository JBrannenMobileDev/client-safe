import 'dart:math';

import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:redux/redux.dart';
import 'NewSessionTypeActions.dart';
import 'NewSessionTypePageState.dart';

final newSessionTypePageReducer = combineReducers<NewSessionTypePageState>([
  TypedReducer<NewSessionTypePageState, ClearNewJobTypeStateAction>(_clearState),
  TypedReducer<NewSessionTypePageState, UpdateJobTypeTitleAction>(_updateTitle),
  TypedReducer<NewSessionTypePageState, LoadExistingSessionTypeData>(_loadExistingJobType),
  TypedReducer<NewSessionTypePageState, UpdateSelectedReminderListAction>(_setSelectedReminder),
  TypedReducer<NewSessionTypePageState, DeleteJobStageAction>(_setStageList),
  TypedReducer<NewSessionTypePageState, SetAllAction>(_setAll),
  TypedReducer<NewSessionTypePageState, UpdateCheckAllRemindersAction>(_setCheckAllRemindersChecked),
  TypedReducer<NewSessionTypePageState, UpdateStageListAction>(_setStages),
  TypedReducer<NewSessionTypePageState, SetCustomStageNameAction>(_setCustomStageName),
  TypedReducer<NewSessionTypePageState, UpdateTaxPercentAction>(_updateTaxPercent),
  TypedReducer<NewSessionTypePageState, SaveNewStageAction>(_insertNewStage),
  TypedReducer<NewSessionTypePageState, UpdateDepositAmountAction>(_updateDepositAmount),
  TypedReducer<NewSessionTypePageState, UpdateTotalCostTextAction>(_updateTotalCost),
  TypedReducer<NewSessionTypePageState, UpdateMinutesAction>(_updateMinutes),
  TypedReducer<NewSessionTypePageState, UpdateHoursAction>(_updateHours),
]);

NewSessionTypePageState _updateMinutes(NewSessionTypePageState previousState, UpdateMinutesAction action) {
  return previousState.copyWith(
    minutes: int.parse(action.minutes?.replaceAll(RegExp(r"\D"), "") ?? '0'),
  );
}

NewSessionTypePageState _updateHours(NewSessionTypePageState previousState, UpdateHoursAction action) {
  return previousState.copyWith(
    hours: int.parse(action.hours?.replaceAll(RegExp(r"\D"), "") ?? '0'),
  );
}

NewSessionTypePageState _updateTaxPercent(NewSessionTypePageState previousState, UpdateTaxPercentAction action){
  double percent = action.taxPercent != null ? double.tryParse(action.taxPercent!.replaceAll('%', '')) ?? 0.0 : 0.0;
  percent = double.parse(percent.toStringAsFixed(1));
  double taxAmount = 0;
  if(action.pageState!.totalCost != 0 && percent != 0) {
    taxAmount = (action.pageState!.totalCost! * percent) / 100;
  }
  return previousState.copyWith(
    taxPercent: percent,
    totalCost: action.pageState!.totalCost!,
    taxAmount: taxAmount,
  );
}

NewSessionTypePageState _updateDepositAmount(NewSessionTypePageState previousState, UpdateDepositAmountAction action){
  String resultCost = action.depositAmount!.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = resultCost.isNotEmpty ? double.parse(resultCost) : 0.0;
  return previousState.copyWith(
    deposit: doubleCost,
  );
}

NewSessionTypePageState _updateTotalCost(NewSessionTypePageState previousState, UpdateTotalCostTextAction action){
  String resultCost = action.flatRateText!.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = resultCost.isNotEmpty ? double.parse(resultCost) : 0.0;
  double taxAmount = (doubleCost * action.pageState!.taxPercent!)/100;
  return previousState.copyWith(
    totalCost: doubleCost,
    taxAmount: taxAmount,
  );
}

NewSessionTypePageState _insertNewStage(NewSessionTypePageState previousState, SaveNewStageAction action) {
  List<JobStage>? stages = action.pageState!.selectedJobStages;
  stages!.insert(0, JobStage(
    stage: action.pageState!.newStageName,
    id: Random().nextInt(999999999) + 14,//makes sure the custom id is greater than 14 and different then any other randomly generated number. hopefully
    imageLocation: 'assets/images/icons/customize.png'
  ));
  return previousState.copyWith(
    selectedJobStages: stages,
  );
}

NewSessionTypePageState _setCustomStageName(NewSessionTypePageState previousState, SetCustomStageNameAction action) {
  return previousState.copyWith(
    newStageName: action.stageName,
  );
}

NewSessionTypePageState _setStages(NewSessionTypePageState previousState, UpdateStageListAction action) {
  return previousState.copyWith(
    selectedJobStages: action.stages,
  );
}

NewSessionTypePageState _setCheckAllRemindersChecked(NewSessionTypePageState previousState, UpdateCheckAllRemindersAction action) {
  List<ReminderDandyLight> selectedRemindersNew = [];
  if(action.isChecked!) {
    selectedRemindersNew.addAll(previousState.allDandyLightReminders!);
  }
  return previousState.copyWith(
    checkAllReminders: action.isChecked,
    selectedReminders: selectedRemindersNew,
  );
}

NewSessionTypePageState _setAll(NewSessionTypePageState previousState, SetAllAction action) {
  return previousState.copyWith(
    allDandyLightReminders: action.allReminders,
  );
}

NewSessionTypePageState _setStageList(NewSessionTypePageState previousState, DeleteJobStageAction action) {
  previousState.selectedJobStages!.removeWhere((jobStage) => jobStage.stage == previousState.selectedJobStages!.elementAt(action.jobStageIndex!).stage);

  return previousState.copyWith(
    selectedJobStages: previousState.selectedJobStages,
  );
}

NewSessionTypePageState _setSelectedReminder(NewSessionTypePageState previousState, UpdateSelectedReminderListAction action) {
  if(action.isChecked!) {
    previousState.selectedReminders!.add(previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!));
  } else {
    previousState.selectedReminders!.removeWhere((reminder) => reminder.documentId == previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!).documentId);
  }

  return previousState.copyWith(
    selectedReminders: previousState.selectedReminders,
  );
}

NewSessionTypePageState _loadExistingJobType(NewSessionTypePageState previousState, LoadExistingSessionTypeData action){
  List<JobStage> stages = action.sessionType!.stages;
  stages.removeAt(0);
  stages.removeLast();
  return previousState.copyWith(
    id: action.sessionType!.id,
    documentId: action.sessionType!.documentId,
    title: action.sessionType!.title,
    selectedJobStages: stages,
    selectedReminders: action.sessionType!.reminders,
    shouldClear: false,
  );
}

NewSessionTypePageState _clearState(NewSessionTypePageState previousState, ClearNewJobTypeStateAction action){
  return NewSessionTypePageState.initial();
}

NewSessionTypePageState _updateTitle(NewSessionTypePageState previousState, UpdateJobTypeTitleAction action){
  return previousState.copyWith(
    title: action.title,
  );
}
