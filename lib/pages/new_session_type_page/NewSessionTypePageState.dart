
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
  final bool? shouldClear;
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
  final List<ReminderDandyLight>? selectedReminders;
  final List<ReminderDandyLight>? allDandyLightReminders;
  final List<JobStage>? selectedJobStages;
  final Function()? onSavePressed;
  final Function()? onCancelPressed;
  final Function()? onDeleteJobTypeSelected;
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

  NewSessionTypePageState({
    @required this.id,
    @required this.documentId,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.title,
    @required this.selectedReminders,
    @required this.selectedJobStages,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onDeleteJobTypeSelected,
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
});

  NewSessionTypePageState copyWith({
    int? id,
    String? documentId,
    bool? saveButtonEnabled,
    bool? shouldClear,
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
    Function()? onSavePressed,
    Function()? onCancelPressed,
    Function()? onDeleteJobTypeSelected,
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
  }){
    return NewSessionTypePageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      title: title ?? this.title,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onDeleteJobTypeSelected: onDeleteJobTypeSelected ?? this.onDeleteJobTypeSelected,
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
    );
  }

  factory NewSessionTypePageState.initial() => NewSessionTypePageState(
        id: null,
        documentId: '',
        saveButtonEnabled: false,
        shouldClear: true,
        title: '',
        onSavePressed: null,
        onCancelPressed: null,
        onDeleteJobTypeSelected: null,
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
      );

  factory NewSessionTypePageState.fromStore(Store<AppState> store) {
    return NewSessionTypePageState(
      id: store.state.newSessionTypePageState!.id,
      saveButtonEnabled: store.state.newSessionTypePageState!.saveButtonEnabled,
      shouldClear: store.state.newSessionTypePageState!.shouldClear,
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
      onSavePressed: () => store.dispatch(SaveNewJobTypeAction(store.state.newSessionTypePageState)),
      onCancelPressed: () => store.dispatch(ClearNewJobTypeStateAction(store.state.newSessionTypePageState)),
      onDeleteJobTypeSelected: () => store.dispatch(DeleteJobTypeAction(store.state.newSessionTypePageState)),
      onTitleChanged: (newTitle) => store.dispatch(UpdateJobTypeTitleAction(store.state.newSessionTypePageState, newTitle)),
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
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      saveButtonEnabled.hashCode ^
      title.hashCode ^
      shouldClear.hashCode ^
      onTotalCostChanged.hashCode ^
      onDepositChanged.hashCode ^
      onTaxPercentChanged.hashCode ^
      onSavePressed.hashCode ^
      onDeleteJobTypeSelected.hashCode ^
      onTitleChanged.hashCode ^
      onReminderSelected.hashCode ^
      saveNewStage.hashCode ^
      onJobStageDeleted.hashCode ^
      selectedReminders.hashCode ^
      selectedJobStages.hashCode ^
      allDandyLightReminders.hashCode ^
      newStageName.hashCode ^
      checkAllTypes.hashCode ^
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
          shouldClear == other.shouldClear &&
          onJobStagesReordered == other.onJobStagesReordered &&
          title == other.title &&
          newStageName == other.newStageName &&
          onSavePressed == other.onSavePressed &&
          saveNewStage == other.saveNewStage &&
          onDeleteJobTypeSelected == other.onDeleteJobTypeSelected &&
          onTitleChanged == other.onTitleChanged &&
          onCustomStageNameChanged == other.onCustomStageNameChanged &&
          onReminderSelected == other.onReminderSelected &&
          onJobStageDeleted == other.onJobStageDeleted &&
          selectedJobStages == other.selectedJobStages &&
          selectedReminders == other.selectedReminders &&
          allDandyLightReminders == other.allDandyLightReminders &&
          checkAllTypes == other.checkAllTypes &&
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
          onCancelPressed == other.onCancelPressed;
}
