
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
  final bool checkAllTypes;
  final bool checkAllReminders;
  final List<ReminderDandyLight> selectedReminders;
  final List<ReminderDandyLight> allDandyLightReminders;
  final List<JobStage> selectedJobStages;
  final List<JobStage> allJobStages;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onDeleteJobTypeSelected;
  final Function(String) onTitleChanged;
  final Function(int, bool) onReminderSelected;
  final Function(int, bool) onJobStageSelected;
  final Function(bool) checkAllTypesChecked;
  final Function(bool) checkAllRemindersChecked;

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
    @required this.allJobStages,
    @required this.checkAllTypes,
    @required this.checkAllTypesChecked,
    @required this.checkAllReminders,
    @required this.checkAllRemindersChecked,
});

  NewJobTypePageState copyWith({
    int id,
    String documentId,
    bool saveButtonEnabled,
    bool shouldClear,
    String title,
    List<ReminderDandyLight> selectedReminders,
    List<JobStage> selectedJobStages,
    List<JobStage> allJobStages,
    List<ReminderDandyLight> allDandyLightReminders,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onDeleteJobTypeSelected,
    Function(String) onTitleChanged,
    Function(int, bool) onReminderSelected,
    Function(int, bool) onJobStageSelected,
    bool checkAllTypes,
    bool checkAllReminders,
    Function(bool) checkAllTypesChecked,
    Function(bool) checkAllRemindersChecked,
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
      onJobStageSelected: onJobStageSelected ?? this.onJobStageSelected,
      selectedReminders: selectedReminders ?? this.selectedReminders,
      selectedJobStages: selectedJobStages ?? this.selectedJobStages,
      allDandyLightReminders: allDandyLightReminders ?? this.allDandyLightReminders,
      allJobStages: allJobStages ?? this.allJobStages,
      checkAllTypes: checkAllTypes ?? this.checkAllTypes,
      checkAllTypesChecked: checkAllTypesChecked ?? this.checkAllTypesChecked,
      checkAllReminders: checkAllReminders ?? this.checkAllReminders,
      checkAllRemindersChecked: checkAllRemindersChecked ?? this.checkAllRemindersChecked,
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
        onJobStageSelected: null,
        selectedJobStages: [],
        selectedReminders: [],
        allDandyLightReminders: [],
        allJobStages: JobStage.AllStagesForNewJobTypeSelection(),
        checkAllTypes: false,
        checkAllTypesChecked: null,
        checkAllReminders: false,
        checkAllRemindersChecked: null,
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
      allJobStages: store.state.newJobTypePageState.allJobStages,
      checkAllTypes: store.state.newJobTypePageState.checkAllTypes,
      checkAllReminders: store.state.newJobTypePageState.checkAllReminders,
      onSavePressed: () => store.dispatch(SaveNewJobTypeAction(store.state.newJobTypePageState)),
      onCancelPressed: () => store.dispatch(ClearNewJobTypeStateAction(store.state.newJobTypePageState)),
      onDeleteJobTypeSelected: () => store.dispatch(DeleteJobTypeAction(store.state.newJobTypePageState)),
      onTitleChanged: (newTitle) => store.dispatch(UpdateJobTypeTitleAction(store.state.newJobTypePageState, newTitle)),
      onReminderSelected: (index, isChecked) => store.dispatch(UpdateSelectedReminderListAction(store.state.newJobTypePageState, index, isChecked)),
      onJobStageSelected: (index, isChecked) => store.dispatch(SetSelectedStagesAction(store.state.newJobTypePageState, index, isChecked)),
      checkAllTypesChecked: (isChecked) => store.dispatch(UpdateCheckAllTypesAction(store.state.newJobTypePageState, isChecked)),
      checkAllRemindersChecked: (isChecked) => store.dispatch(UpdateCheckAllRemindersAction(store.state.newJobTypePageState, isChecked)),
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
      onJobStageSelected.hashCode ^
      allJobStages.hashCode ^
      selectedReminders.hashCode ^
      selectedJobStages.hashCode ^
      allDandyLightReminders.hashCode ^
      checkAllTypes.hashCode ^
      checkAllTypesChecked.hashCode ^
      checkAllReminders.hashCode ^
      checkAllRemindersChecked.hashCode ^
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
          checkAllTypes == other.checkAllTypes &&
          checkAllTypesChecked == other.checkAllTypesChecked &&
          checkAllReminders == other.checkAllReminders &&
          checkAllRemindersChecked == other.checkAllRemindersChecked &&
          onCancelPressed == other.onCancelPressed;
}
