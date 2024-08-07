
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import 'NewSessionTypeActions.dart';

@immutable
class NewSessionTypePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int? id;
  final String? documentId;
  final bool? saveButtonEnabled;
  final String? title;
  final String? newStageName;
  final bool? checkAllTypes;
  final bool? checkAllReminders;
  final double? totalCost;
  final double? deposit;
  final double? taxPercent;
  final double? taxAmount;
  final int? minutes;
  final int? hours;
  final bool? stagesComplete;
  final bool? remindersComplete;
  final List<ReminderDandyLight>? selectedReminders;
  final List<ReminderDandyLight>? allDandyLightReminders;
  final List<JobStage>? selectedJobStages;
  final Function()? onSavePressed;
  final Function()? onCancelPressed;
  final Function()? onDeleteSessionTypeSelected;
  final Function(String)? onTitleChanged;
  final Function(String)? onCustomStageNameChanged;
  final Function(int, bool)? onReminderSelected;
  final Function(int)? onJobStageDeleted;
  final Function(List<JobStage>)? onJobStagesReordered;
  final Function(bool)? checkAllRemindersChecked;
  final Function()? saveNewStage;
  final Function(String)? onTotalCostChanged;
  final Function(String)? onDepositChanged;
  final Function(String)? onTaxPercentChanged;
  final Function(String)? onMinutesChanged;
  final Function(String)? onHoursChanged;
  final Function(bool)? onJobStagesComplete;
  final Function(bool)? onRemindersComplete;

  NewSessionTypePageState({
    @required this.id,
    @required this.documentId,
    @required this.saveButtonEnabled,
    @required this.title,
    @required this.selectedReminders,
    @required this.selectedJobStages,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onDeleteSessionTypeSelected,
    @required this.onTitleChanged,
    @required this.onReminderSelected,
    @required this.onJobStageDeleted,
    @required this.allDandyLightReminders,
    @required this.checkAllTypes,
    @required this.checkAllReminders,
    @required this.checkAllRemindersChecked,
    @required this.onJobStagesReordered,
    @required this.onCustomStageNameChanged,
    @required this.newStageName,
    @required this.saveNewStage,
    @required this.totalCost,
    @required this.deposit,
    @required this.taxPercent,
    @required this.taxAmount,
    @required this.onDepositChanged,
    @required this.onTaxPercentChanged,
    @required this.onTotalCostChanged,
    @required this.minutes,
    @required this.hours,
    @required this.onMinutesChanged,
    @required this.onHoursChanged,
    @required this.stagesComplete,
    @required this.onJobStagesComplete,
    @required this.remindersComplete,
    @required this.onRemindersComplete,
});

  NewSessionTypePageState copyWith({
    int? id,
    String? documentId,
    bool? saveButtonEnabled,
    String? title,
    String? newStageName,
    List<ReminderDandyLight>? selectedReminders,
    List<JobStage>? selectedJobStages,
    List<ReminderDandyLight>? allDandyLightReminders,
    double? totalCost,
    double? deposit,
    double? taxPercent,
    double? taxAmount,
    int? minutes,
    int? hours,
    bool? stagesComplete,
    bool? remindersComplete,
    Function()? onSavePressed,
    Function()? onCancelPressed,
    Function()? onDeleteSessionTypeSelected,
    Function(String)? onTitleChanged,
    Function(int, bool)? onReminderSelected,
    Function(int)? onJobStageDeleted,
    bool? checkAllTypes,
    bool? checkAllReminders,
    Function(bool)? checkAllRemindersChecked,
    Function(List<JobStage>)? onJobStagesReordered,
    Function(String)? onCustomStageNameChanged,
    Function()? saveNewStage,
    Function(String)? onTotalCostChanged,
    Function(String)? onDepositChanged,
    Function(String)? onTaxPercentChanged,
    Function(String)? onMinutesChanged,
    Function(String)? onHoursChanged,
    Function(bool)? onJobStagesComplete,
    Function(bool)? onRemindersComplete,
  }){
    return NewSessionTypePageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      title: title ?? this.title,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onDeleteSessionTypeSelected: onDeleteSessionTypeSelected ?? this.onDeleteSessionTypeSelected,
      onTitleChanged: onTitleChanged ?? this.onTitleChanged,
      onReminderSelected: onReminderSelected ?? this.onReminderSelected,
      onJobStageDeleted: onJobStageDeleted ?? this.onJobStageDeleted,
      selectedReminders: selectedReminders ?? this.selectedReminders,
      selectedJobStages: selectedJobStages ?? this.selectedJobStages,
      allDandyLightReminders: allDandyLightReminders ?? this.allDandyLightReminders,
      checkAllTypes: checkAllTypes ?? this.checkAllTypes,
      checkAllReminders: checkAllReminders ?? this.checkAllReminders,
      checkAllRemindersChecked: checkAllRemindersChecked ?? this.checkAllRemindersChecked,
      onJobStagesReordered: onJobStagesReordered ?? this.onJobStagesReordered,
      onCustomStageNameChanged: onCustomStageNameChanged ?? this.onCustomStageNameChanged,
      newStageName: newStageName ?? this.newStageName,
      saveNewStage: saveNewStage ?? this.saveNewStage,
      totalCost: totalCost ?? this.totalCost,
      deposit: deposit ?? this.deposit,
      taxPercent: taxPercent ?? this.taxPercent,
      taxAmount: taxAmount ?? this.taxAmount,
      onTotalCostChanged: onTotalCostChanged ?? this.onTotalCostChanged,
      onDepositChanged: onDepositChanged ?? this.onDepositChanged,
      onTaxPercentChanged: onTaxPercentChanged ?? this.onTaxPercentChanged,
      minutes: minutes ?? this.minutes,
      hours: hours ?? this.hours,
      onMinutesChanged: onMinutesChanged ?? this.onMinutesChanged,
      onHoursChanged: onHoursChanged ?? this.onHoursChanged,
      stagesComplete: stagesComplete ?? this.stagesComplete,
      onJobStagesComplete: onJobStagesComplete ?? this.onJobStagesComplete,
      remindersComplete: remindersComplete ?? this.remindersComplete,
      onRemindersComplete: onRemindersComplete ?? this.onRemindersComplete,
    );
  }

  factory NewSessionTypePageState.initial() => NewSessionTypePageState(
        id: null,
        documentId: '',
        saveButtonEnabled: false,
        title: '',
        onSavePressed: null,
        onCancelPressed: null,
        onDeleteSessionTypeSelected: null,
        onTitleChanged: null,
        onReminderSelected: null,
        onJobStageDeleted: null,
        selectedJobStages: JobStage.AllStagesForNewJobTypeSelection(),
        selectedReminders: [],
        allDandyLightReminders: [],
        checkAllTypes: false,
        checkAllReminders: false,
        checkAllRemindersChecked: null,
        onJobStagesReordered: null,
        onCustomStageNameChanged: null,
        newStageName: '',
        saveNewStage: null,
        totalCost: 0.0,
        deposit: 0.0,
        taxPercent: 0.0,
        taxAmount: 0.0,
        onTotalCostChanged: null,
        onDepositChanged: null,
        onTaxPercentChanged: null,
        minutes: 0,
        hours: 0,
        onMinutesChanged: null,
        onHoursChanged: null,
        stagesComplete: false,
        onJobStagesComplete: null,
        remindersComplete: false,
        onRemindersComplete: null,
      );

  factory NewSessionTypePageState.fromStore(Store<AppState> store) {
    return NewSessionTypePageState(
      id: store.state.newSessionTypePageState!.id,
      saveButtonEnabled: store.state.newSessionTypePageState!.saveButtonEnabled,
      title: store.state.newSessionTypePageState!.title,
      documentId: store.state.newSessionTypePageState!.documentId,
      selectedReminders: store.state.newSessionTypePageState!.selectedReminders,
      selectedJobStages: store.state.newSessionTypePageState!.selectedJobStages,
      allDandyLightReminders: store.state.newSessionTypePageState!.allDandyLightReminders,
      checkAllTypes: store.state.newSessionTypePageState!.checkAllTypes,
      checkAllReminders: store.state.newSessionTypePageState!.checkAllReminders,
      newStageName: store.state.newSessionTypePageState!.newStageName,
      totalCost: store.state.newSessionTypePageState!.totalCost,
      deposit: store.state.newSessionTypePageState!.deposit,
      taxPercent: store.state.newSessionTypePageState!.taxPercent,
      taxAmount: store.state.newSessionTypePageState!.taxAmount,
      minutes: store.state.newSessionTypePageState!.minutes,
      hours: store.state.newSessionTypePageState!.hours,
      stagesComplete: store.state.newSessionTypePageState!.stagesComplete,
      remindersComplete: store.state.newSessionTypePageState!.remindersComplete,
      onSavePressed: () => store.dispatch(SaveNewSessionTypeAction(store.state.newSessionTypePageState)),
      onCancelPressed: () => store.dispatch(ClearNewSessionTypeStateAction(store.state.newSessionTypePageState)),
      onDeleteSessionTypeSelected: () => store.dispatch(DeleteSessionTypeAction(store.state.newSessionTypePageState)),
      onTitleChanged: (newTitle) => store.dispatch(UpdateJobSessionTypeNameAction(store.state.newSessionTypePageState, newTitle)),
      onReminderSelected: (index, isChecked) => store.dispatch(UpdateSelectedReminderListAction(store.state.newSessionTypePageState, index, isChecked)),
      onJobStageDeleted: (index) => store.dispatch(DeleteJobStageAction(store.state.newSessionTypePageState, index)),
      checkAllRemindersChecked: (isChecked) => store.dispatch(UpdateCheckAllRemindersAction(store.state.newSessionTypePageState, isChecked)),
      onJobStagesReordered: (stages) => store.dispatch(UpdateStageListAction(store.state.newSessionTypePageState, stages)),
      onCustomStageNameChanged: (stageName) => store.dispatch(SetCustomStageNameAction(store.state.newSessionTypePageState, stageName)),
      saveNewStage: () => store.dispatch(SaveNewStageAction(store.state.newSessionTypePageState)),
      onTotalCostChanged: (cost) => store.dispatch(UpdateTotalCostTextAction(store.state.newSessionTypePageState, cost)),
      onDepositChanged: (deposit) => store.dispatch(UpdateDepositAmountAction(store.state.newSessionTypePageState, deposit)),
      onTaxPercentChanged: (percent) => store.dispatch(UpdateTaxPercentAction(store.state.newSessionTypePageState, percent)),
      onMinutesChanged: (minutes) => store.dispatch(UpdateMinutesAction(store.state.newSessionTypePageState, minutes)),
      onHoursChanged: (hours) => store.dispatch(UpdateHoursAction(store.state.newSessionTypePageState, hours)),
      onJobStagesComplete: (complete) => store.dispatch(SetStageSelectionCompleteAction(store.state.newSessionTypePageState, complete)),
      onRemindersComplete: (complete) => store.dispatch(SetRemindersSelectionCompleteAction(store.state.newSessionTypePageState, complete)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      saveButtonEnabled.hashCode ^
      title.hashCode ^
      onTotalCostChanged.hashCode ^
      onDepositChanged.hashCode ^
      onTaxPercentChanged.hashCode ^
      onSavePressed.hashCode ^
      remindersComplete.hashCode ^
      onDeleteSessionTypeSelected.hashCode ^
      onTitleChanged.hashCode ^
      stagesComplete.hashCode ^
      onReminderSelected.hashCode ^
      saveNewStage.hashCode ^
      onJobStageDeleted.hashCode ^
      selectedReminders.hashCode ^
      selectedJobStages.hashCode ^
      allDandyLightReminders.hashCode ^
      newStageName.hashCode ^
      checkAllTypes.hashCode ^
      onJobStagesComplete.hashCode ^
      checkAllReminders.hashCode ^
      checkAllRemindersChecked.hashCode ^
      onJobStagesReordered.hashCode ^
      onCustomStageNameChanged.hashCode ^
      totalCost.hashCode ^
      deposit.hashCode ^
      taxPercent.hashCode ^
      taxAmount.hashCode ^
      minutes.hashCode ^
      hours.hashCode ^
      onMinutesChanged.hashCode ^
      onHoursChanged.hashCode ^
      onRemindersComplete.hashCode ^
      onCancelPressed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewSessionTypePageState &&
          id == other.id &&
          documentId == other.documentId &&
          onTotalCostChanged == other.onTotalCostChanged &&
          onDepositChanged == other.onDepositChanged &&
          onTaxPercentChanged == other.onTaxPercentChanged &&
          saveButtonEnabled == other.saveButtonEnabled &&
          onJobStagesReordered == other.onJobStagesReordered &&
          title == other.title &&
          newStageName == other.newStageName &&
          onSavePressed == other.onSavePressed &&
          saveNewStage == other.saveNewStage &&
          onDeleteSessionTypeSelected == other.onDeleteSessionTypeSelected &&
          onTitleChanged == other.onTitleChanged &&
          remindersComplete == other.remindersComplete &&
          onJobStagesComplete == other.onJobStagesComplete &&
          onCustomStageNameChanged == other.onCustomStageNameChanged &&
          onReminderSelected == other.onReminderSelected &&
          onJobStageDeleted == other.onJobStageDeleted &&
          selectedJobStages == other.selectedJobStages &&
          selectedReminders == other.selectedReminders &&
          allDandyLightReminders == other.allDandyLightReminders &&
          checkAllTypes == other.checkAllTypes &&
          stagesComplete == other.stagesComplete &&
          checkAllReminders == other.checkAllReminders &&
          checkAllRemindersChecked == other.checkAllRemindersChecked &&
          totalCost == other.totalCost &&
          deposit == other.deposit &&
          taxPercent == other.taxPercent &&
          taxAmount == other.taxAmount &&
          minutes == other.minutes &&
          hours == other.hours &&
          onMinutesChanged == other.onMinutesChanged &&
          onHoursChanged == other.onHoursChanged &&
          onRemindersComplete == other.onRemindersComplete &&
          onCancelPressed == other.onCancelPressed;
}
