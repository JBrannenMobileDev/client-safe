import 'dart:ffi';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import 'NewJobTypeActions.dart';

@immutable
class NewJobTypePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final String documentId;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String title;
  final double flatRate;
  final bool checkAll;
  final List<ReminderDandyLight> selectedReminders;
  final List<ReminderDandyLight> allDandyLightReminders;
  final List<JobStage> selectedJobStages;
  final List<JobStage> allJobStages;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onDeleteJobTypeSelected;
  final Function(String) onTitleChanged;
  final Function(ReminderDandyLight) onReminderSelected;
  final Function(int, bool) onJobStageSelected;
  final Function(String) onFlatRateTextChanged;
  final Function(bool) checkAllChecked;

  NewJobTypePageState({
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
    @required this.onJobStageSelected,
    @required this.allDandyLightReminders,
    @required this.flatRate,
    @required this.onFlatRateTextChanged,
    @required this.allJobStages,
    @required this.checkAll,
    @required this.checkAllChecked,
});

  NewJobTypePageState copyWith({
    int id,
    String documentId,
    bool saveButtonEnabled,
    bool shouldClear,
    String title,
    double flatRate,
    List<ReminderDandyLight> selectedReminders,
    List<JobStage> selectedJobStages,
    List<JobStage> allJobStages,
    List<ReminderDandyLight> allDandyLightReminders,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onDeleteJobTypeSelected,
    Function(String) onTitleChanged,
    Function(ReminderDandyLight) onReminderSelected,
    Function(int, bool) onJobStageSelected,
    Function(String) onFlatRateTextChanged,
    bool checkAll,
    Function(bool) checkAllChecked,
  }){
    return NewJobTypePageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      title: title ?? this.title,
      flatRate: flatRate ?? this.flatRate,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onDeleteJobTypeSelected: onDeleteJobTypeSelected ?? this.onDeleteJobTypeSelected,
      onTitleChanged: onTitleChanged ?? this.onTitleChanged,
      onReminderSelected: onReminderSelected ?? this.onReminderSelected,
      onJobStageSelected: onJobStageSelected ?? this.onJobStageSelected,
      selectedReminders: selectedReminders ?? this.selectedReminders,
      selectedJobStages: selectedJobStages ?? this.selectedJobStages,
      allDandyLightReminders: allDandyLightReminders ?? this.allDandyLightReminders,
      onFlatRateTextChanged: onFlatRateTextChanged ?? this.onFlatRateTextChanged,
      allJobStages: allJobStages ?? this.allJobStages,
      checkAll: checkAll ?? this.checkAll,
      checkAllChecked: checkAllChecked ?? this.checkAllChecked,
    );
  }

  factory NewJobTypePageState.initial() => NewJobTypePageState(
        id: null,
        documentId: '',
        saveButtonEnabled: false,
        shouldClear: true,
        title: '',
        flatRate: 0,
        onSavePressed: null,
        onCancelPressed: null,
        onDeleteJobTypeSelected: null,
        onTitleChanged: null,
        onReminderSelected: null,
        onJobStageSelected: null,
        selectedJobStages: [],
        selectedReminders: [],
        allDandyLightReminders: [],
        onFlatRateTextChanged: null,
        allJobStages: JobStage.AllStages(),
        checkAll: false,
        checkAllChecked: null,
      );

  factory NewJobTypePageState.fromStore(Store<AppState> store) {
    return NewJobTypePageState(
      id: store.state.newJobTypePageState.id,
      saveButtonEnabled: store.state.newJobTypePageState.saveButtonEnabled,
      shouldClear: store.state.newJobTypePageState.shouldClear,
      title: store.state.newJobTypePageState.title,
      documentId: store.state.newJobTypePageState.documentId,
      selectedReminders: store.state.newJobTypePageState.selectedReminders,
      selectedJobStages: store.state.newJobTypePageState.selectedJobStages,
      allDandyLightReminders: store.state.newJobTypePageState.allDandyLightReminders,
      flatRate: store.state.newJobTypePageState.flatRate,
      allJobStages: store.state.newJobTypePageState.allJobStages,
      checkAll: store.state.newJobTypePageState.checkAll,
      onSavePressed: () => store.dispatch(SaveNewJobTypeAction(store.state.newJobTypePageState)),
      onCancelPressed: () => store.dispatch(ClearNewJobTypeStateAction(store.state.newJobTypePageState)),
      onDeleteJobTypeSelected: () => store.dispatch(DeleteJobTypeAction(store.state.newJobTypePageState)),
      onTitleChanged: (newTitle) => store.dispatch(UpdateJobTypeTitleAction(store.state.newJobTypePageState, newTitle)),
      onReminderSelected: (selectedReminder) => store.dispatch(UpdateSelectedReminderListAction(store.state.newJobTypePageState, selectedReminder)),
      onJobStageSelected: (index, isChecked) => store.dispatch(SetSelectedStagesAction(store.state.newJobTypePageState, index, isChecked)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateTextAction(store.state.newJobTypePageState, flatRateText)),
      checkAllChecked: (isChecked) => store.dispatch(UpdateCheckAllAction(store.state.newJobTypePageState, isChecked)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      saveButtonEnabled.hashCode ^
      title.hashCode ^
      flatRate.hashCode ^
      shouldClear.hashCode ^
      onSavePressed.hashCode ^
      onDeleteJobTypeSelected.hashCode ^
      onTitleChanged.hashCode ^
      onReminderSelected.hashCode ^
      onJobStageSelected.hashCode ^
      allJobStages.hashCode ^
      selectedReminders.hashCode ^
      selectedJobStages.hashCode ^
      allDandyLightReminders.hashCode ^
      onFlatRateTextChanged.hashCode ^
      checkAll.hashCode ^
      checkAllChecked.hashCode ^
      onCancelPressed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobTypePageState &&
          id == other.id &&
          documentId == other.documentId &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          title == other.title &&
          onSavePressed == other.onSavePressed &&
          onDeleteJobTypeSelected == other.onDeleteJobTypeSelected &&
          onTitleChanged == other.onTitleChanged &&
          allJobStages == other.allJobStages &&
          onReminderSelected == other.onReminderSelected &&
          onJobStageSelected == other.onJobStageSelected &&
          selectedJobStages == other.selectedJobStages &&
          selectedReminders == other.selectedReminders &&
          allDandyLightReminders == other.allDandyLightReminders &&
          onFlatRateTextChanged == other.onFlatRateTextChanged &&
          flatRate == other.flatRate &&
          checkAll == other.checkAll &&
          checkAllChecked == other.checkAllChecked &&
          onCancelPressed == other.onCancelPressed;
}
