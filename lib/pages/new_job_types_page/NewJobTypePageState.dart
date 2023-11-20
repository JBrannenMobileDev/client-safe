
import 'package:dandylight/AppState.dart';
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
  final String newStageName;
  final bool checkAllTypes;
  final bool checkAllReminders;
  final List<ReminderDandyLight> selectedReminders;
  final List<ReminderDandyLight> allDandyLightReminders;
  final List<JobStage> selectedJobStages;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onDeleteJobTypeSelected;
  final Function(String) onTitleChanged;
  final Function(String) onCustomStageNameChanged;
  final Function(int, bool) onReminderSelected;
  final Function(int) onJobStageDeleted;
  final Function(List<JobStage>) onJobStagesReordered;
  final Function(bool) checkAllRemindersChecked;
  final Function() saveNewStage;

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
    @required this.onJobStageDeleted,
    @required this.allDandyLightReminders,
    @required this.checkAllTypes,
    @required this.checkAllReminders,
    @required this.checkAllRemindersChecked,
    @required this.onJobStagesReordered,
    @required this.onCustomStageNameChanged,
    @required this.newStageName,
    @required this.saveNewStage,
});

  NewJobTypePageState copyWith({
    int id,
    String documentId,
    bool saveButtonEnabled,
    bool shouldClear,
    String title,
    String newStageName,
    List<ReminderDandyLight> selectedReminders,
    List<JobStage> selectedJobStages,
    List<ReminderDandyLight> allDandyLightReminders,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onDeleteJobTypeSelected,
    Function(String) onTitleChanged,
    Function(int, bool) onReminderSelected,
    Function(int) onJobStageDeleted,
    bool checkAllTypes,
    bool checkAllReminders,
    Function(bool) checkAllRemindersChecked,
    Function(List<JobStage>) onJobStagesReordered,
    Function(String) onCustomStageNameChanged,
    Function() saveNewStage,
  }){
    return NewJobTypePageState(
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
    );
  }

  factory NewJobTypePageState.initial() => NewJobTypePageState(
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
      checkAllTypes: store.state.newJobTypePageState.checkAllTypes,
      checkAllReminders: store.state.newJobTypePageState.checkAllReminders,
      newStageName: store.state.newJobTypePageState.newStageName,
      onSavePressed: () => store.dispatch(SaveNewJobTypeAction(store.state.newJobTypePageState)),
      onCancelPressed: () => store.dispatch(ClearNewJobTypeStateAction(store.state.newJobTypePageState)),
      onDeleteJobTypeSelected: () => store.dispatch(DeleteJobTypeAction(store.state.newJobTypePageState)),
      onTitleChanged: (newTitle) => store.dispatch(UpdateJobTypeTitleAction(store.state.newJobTypePageState, newTitle)),
      onReminderSelected: (index, isChecked) => store.dispatch(UpdateSelectedReminderListAction(store.state.newJobTypePageState, index, isChecked)),
      onJobStageDeleted: (index) => store.dispatch(DeleteJobStageAction(store.state.newJobTypePageState, index)),
      checkAllRemindersChecked: (isChecked) => store.dispatch(UpdateCheckAllRemindersAction(store.state.newJobTypePageState, isChecked)),
      onJobStagesReordered: (stages) => store.dispatch(UpdateStageListAction(store.state.newJobTypePageState, stages)),
      onCustomStageNameChanged: (stageName) => store.dispatch(SetCustomStageNameAction(store.state.newJobTypePageState, stageName)),
      saveNewStage: () => store.dispatch(SaveNewStageAction(store.state.newJobTypePageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      saveButtonEnabled.hashCode ^
      title.hashCode ^
      shouldClear.hashCode ^
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
      onCancelPressed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobTypePageState &&
          id == other.id &&
          documentId == other.documentId &&
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
          onCancelPressed == other.onCancelPressed;
}
