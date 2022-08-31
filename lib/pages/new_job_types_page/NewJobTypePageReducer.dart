import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:redux/redux.dart';
import '../../models/JobStage.dart';
import 'NewJobTypeActions.dart';
import 'NewJobTypePageState.dart';

final newJobTypePageReducer = combineReducers<NewJobTypePageState>([
  TypedReducer<NewJobTypePageState, ClearNewJobTypeStateAction>(_clearState),
  TypedReducer<NewJobTypePageState, UpdateJobTypeTitleAction>(_updateTitle),
  TypedReducer<NewJobTypePageState, LoadExistingJobTypeData>(_loadExistingJobType),
  TypedReducer<NewJobTypePageState, UpdateSelectedReminderListAction>(_setSelectedReminder),
  TypedReducer<NewJobTypePageState, SetSelectedStagesAction>(_setStageList),
  TypedReducer<NewJobTypePageState, SetAllAction>(_setAll),
  TypedReducer<NewJobTypePageState, UpdateCheckAllTypesAction>(_setCheckAllTypesChecked),
  TypedReducer<NewJobTypePageState, UpdateCheckAllRemindersAction>(_setCheckAllRemindersChecked),
]);

NewJobTypePageState _setCheckAllTypesChecked(NewJobTypePageState previousState, UpdateCheckAllTypesAction action) {
  List<JobStage> selectedJobStagesNew = [];
  if(action.isChecked) {
    selectedJobStagesNew.addAll(previousState.allJobStages);
  }
  return previousState.copyWith(
    checkAllTypes: action.isChecked,
    selectedJobStages: selectedJobStagesNew,
  );
}

NewJobTypePageState _setCheckAllRemindersChecked(NewJobTypePageState previousState, UpdateCheckAllRemindersAction action) {
  List<ReminderDandyLight> selectedRemindersNew = [];
  if(action.isChecked) {
    selectedRemindersNew.addAll(previousState.allDandyLightReminders);
  }
  return previousState.copyWith(
    checkAllReminders: action.isChecked,
    selectedReminders: selectedRemindersNew,
  );
}

NewJobTypePageState _setAll(NewJobTypePageState previousState, SetAllAction action) {
  return previousState.copyWith(
    allDandyLightReminders: action.allReminders,
  );
}

NewJobTypePageState _setStageList(NewJobTypePageState previousState, SetSelectedStagesAction action) {
  if(action.isChecked) {
    previousState.selectedJobStages.add(previousState.allJobStages.elementAt(action.jobStageIndex));
  } else {
    previousState.selectedJobStages.removeWhere((jobStage) => jobStage.stage == previousState.allJobStages.elementAt(action.jobStageIndex).stage);
  }

  return previousState.copyWith(
    selectedJobStages: previousState.selectedJobStages,
  );
}

NewJobTypePageState _setSelectedReminder(NewJobTypePageState previousState, UpdateSelectedReminderListAction action) {
  if(action.isChecked) {
    previousState.selectedReminders.add(previousState.allDandyLightReminders.elementAt(action.reminderStageIndex));
  } else {
    previousState.selectedReminders.removeWhere((reminder) => reminder.documentId == previousState.allDandyLightReminders.elementAt(action.reminderStageIndex).documentId);
  }

  return previousState.copyWith(
    selectedReminders: previousState.selectedReminders,
  );
}

NewJobTypePageState _loadExistingJobType(NewJobTypePageState previousState, LoadExistingJobTypeData action){

  return previousState.copyWith(
    id: action.jobType.id,
    documentId: action.jobType.documentId,
    title: action.jobType.title,
    selectedJobStages: action.jobType.stages,
    selectedReminders: action.jobType.reminders,
    shouldClear: false,
  );
}

NewJobTypePageState _clearState(NewJobTypePageState previousState, ClearNewJobTypeStateAction action){
  return NewJobTypePageState.initial();
}

NewJobTypePageState _updateTitle(NewJobTypePageState previousState, UpdateJobTypeTitleAction action){
  return previousState.copyWith(
    title: action.title,
  );
}
