import 'dart:math';

import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:redux/redux.dart';
import 'NewSessionTypeActions.dart';
import 'NewSessionTypePageState.dart';

final newSessionTypePageReducer = combineReducers<NewSessionTypePageState>([
  TypedReducer<NewSessionTypePageState, ClearNewSessionTypeStateAction>(_clearState),
  TypedReducer<NewSessionTypePageState, UpdateJobSessionTypeNameAction>(_updateTitle),
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
  TypedReducer<NewSessionTypePageState, SetStageSelectionCompleteAction>(_setStageSelectionComplete),
  TypedReducer<NewSessionTypePageState, SetRemindersSelectionCompleteAction>(_setRemindersSelectionComplete),
]);

NewSessionTypePageState _setStageSelectionComplete(NewSessionTypePageState previousState, SetStageSelectionCompleteAction action) {
  return previousState.copyWith(
    stagesComplete: action.complete,
    saveButtonEnabled: canEnableSaveButton(
      previousState.title,
      previousState.hours,
      previousState.minutes,
      previousState.totalCost,
      action.complete,
      previousState.remindersComplete,
    ),
  );
}

NewSessionTypePageState _setRemindersSelectionComplete(NewSessionTypePageState previousState, SetRemindersSelectionCompleteAction action) {
  return previousState.copyWith(
    remindersComplete: action.complete,
    saveButtonEnabled: canEnableSaveButton(
      previousState.title,
      previousState.hours,
      previousState.minutes,
      previousState.totalCost,
      previousState.stagesComplete,
      action.complete,
    ),
  );
}

NewSessionTypePageState _updateMinutes(NewSessionTypePageState previousState, UpdateMinutesAction action) {
  int minutes = int.parse(action.minutes?.replaceAll(RegExp(r"\D"), "") ?? '0');
  return previousState.copyWith(
    minutes: minutes,
    saveButtonEnabled: canEnableSaveButton(
        previousState.title,
        previousState.hours,
        minutes,
        previousState.totalCost,
        previousState.stagesComplete,
        previousState.remindersComplete,
    ),
  );
}

NewSessionTypePageState _updateHours(NewSessionTypePageState previousState, UpdateHoursAction action) {
  int hours = int.parse(action.hours?.replaceAll(RegExp(r"\D"), "") ?? '0');
  return previousState.copyWith(
    hours: hours,
    saveButtonEnabled: canEnableSaveButton(
        previousState.title,
        hours,
        previousState.minutes,
        previousState.totalCost,
        previousState.stagesComplete,
        previousState.remindersComplete
    )
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

  print('doubleCost = $doubleCost');
  print('taxAmount = $taxAmount');
  return previousState.copyWith(
    totalCost: doubleCost,
    taxAmount: taxAmount,
    saveButtonEnabled: canEnableSaveButton(
        previousState.title,
        previousState.hours,
        previousState.minutes,
        doubleCost,
        previousState.stagesComplete,
        previousState.remindersComplete
    )
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
    saveButtonEnabled: canEnableSaveButton(
        previousState.title,
        previousState.hours,
        previousState.minutes,
        previousState.totalCost,
        previousState.stagesComplete,
        previousState.remindersComplete,
    )
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
  List<ReminderDandyLight> selectedReminders = previousState.selectedReminders ?? [];
  if(action.isChecked!) {
    selectedReminders.add(previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!));
  } else {
    selectedReminders.removeWhere((reminder) => reminder.documentId == previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!).documentId);
  }

  return previousState.copyWith(
    selectedReminders: previousState.selectedReminders,
    saveButtonEnabled: canEnableSaveButton(
        previousState.title,
        previousState.hours,
        previousState.minutes,
        previousState.totalCost,
        previousState.stagesComplete,
        previousState.remindersComplete,
    )
  );
}

NewSessionTypePageState _loadExistingJobType(NewSessionTypePageState previousState, LoadExistingSessionTypeData action){
  List<JobStage> stages = [];
  stages.addAll(action.sessionType!.stages);
  stages.removeAt(0);
  stages.removeLast();
  var emptyState = NewSessionTypePageState.initial();

  double taxAmount = 0;
  if(action.sessionType!.totalCost != 0 && action.sessionType?.salesTaxPercent != 0) {
    taxAmount = (action.sessionType!.totalCost! * (action.sessionType?.salesTaxPercent ?? 0)) / 100;
  }

  return emptyState.copyWith(
    id: action.sessionType!.id,
    documentId: action.sessionType!.documentId,
    title: action.sessionType!.title,
    selectedJobStages: stages,
    selectedReminders: action.sessionType!.reminders,
    stagesComplete: true,
    remindersComplete: true,
    taxAmount: taxAmount,
    taxPercent: action.sessionType!.salesTaxPercent,
  );
}

NewSessionTypePageState _clearState(NewSessionTypePageState previousState, ClearNewSessionTypeStateAction action){
  return NewSessionTypePageState.initial();
}

NewSessionTypePageState _updateTitle(NewSessionTypePageState previousState, UpdateJobSessionTypeNameAction action){
  return previousState.copyWith(
    title: action.title,
  );
}

bool canEnableSaveButton(
  String? title,
  int? hours,
  int? minutes,
  double? price,
  bool? stagesComplete,
  bool? remindersComplete,
) {
  bool titleError = title?.isEmpty ?? true;
  bool durationError = (hours != null && hours > 0) && (minutes != null && minutes > 0);
  bool priceError = price != null && price <= 0;
  bool stagesError = !(stagesComplete ?? true);
  bool remindersError = !(remindersComplete ?? true);
  return !titleError && !durationError && !priceError && !stagesError && !remindersError;
}
