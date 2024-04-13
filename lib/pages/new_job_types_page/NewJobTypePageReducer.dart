import 'dart:math';

import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:redux/redux.dart';
import 'NewJobTypeActions.dart';
import 'NewJobTypePageState.dart';

final newJobTypePageReducer = combineReducers<NewJobTypePageState>([
  TypedReducer<NewJobTypePageState, ClearNewJobTypeStateAction>(_clearState),
  TypedReducer<NewJobTypePageState, UpdateJobTypeTitleAction>(_updateTitle),
  TypedReducer<NewJobTypePageState, LoadExistingJobTypeData>(_loadExistingJobType),
  TypedReducer<NewJobTypePageState, UpdateSelectedReminderListAction>(_setSelectedReminder),
  TypedReducer<NewJobTypePageState, DeleteJobStageAction>(_setStageList),
  TypedReducer<NewJobTypePageState, SetAllAction>(_setAll),
  TypedReducer<NewJobTypePageState, UpdateCheckAllRemindersAction>(_setCheckAllRemindersChecked),
  TypedReducer<NewJobTypePageState, UpdateStageListAction>(_setStages),
  TypedReducer<NewJobTypePageState, SetCustomStageNameAction>(_setCustomStageName),
  TypedReducer<NewJobTypePageState, SaveNewStageAction>(_insertNewStage),
]);

NewJobTypePageState _insertNewStage(NewJobTypePageState previousState, SaveNewStageAction action) {
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

NewJobTypePageState _setCustomStageName(NewJobTypePageState previousState, SetCustomStageNameAction action) {
  return previousState.copyWith(
    newStageName: action.stageName,
  );
}

NewJobTypePageState _setStages(NewJobTypePageState previousState, UpdateStageListAction action) {
  return previousState.copyWith(
    selectedJobStages: action.stages,
  );
}

NewJobTypePageState _setCheckAllRemindersChecked(NewJobTypePageState previousState, UpdateCheckAllRemindersAction action) {
  List<ReminderDandyLight> selectedRemindersNew = [];
  if(action.isChecked!) {
    selectedRemindersNew.addAll(previousState.allDandyLightReminders!);
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

NewJobTypePageState _setStageList(NewJobTypePageState previousState, DeleteJobStageAction action) {
  previousState.selectedJobStages!.removeWhere((jobStage) => jobStage.stage == previousState.selectedJobStages!.elementAt(action.jobStageIndex!).stage);

  return previousState.copyWith(
    selectedJobStages: previousState.selectedJobStages,
  );
}

NewJobTypePageState _setSelectedReminder(NewJobTypePageState previousState, UpdateSelectedReminderListAction action) {
  if(action.isChecked!) {
    previousState.selectedReminders!.add(previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!));
  } else {
    previousState.selectedReminders!.removeWhere((reminder) => reminder.documentId == previousState.allDandyLightReminders!.elementAt(action.reminderStageIndex!).documentId);
  }

  return previousState.copyWith(
    selectedReminders: previousState.selectedReminders,
  );
}

NewJobTypePageState _loadExistingJobType(NewJobTypePageState previousState, LoadExistingJobTypeData action){
  List<JobStage> stages = action.jobType!.stages!;
  stages.removeAt(0);
  stages.removeLast();
  return previousState.copyWith(
    id: action.jobType!.id,
    documentId: action.jobType!.documentId,
    title: action.jobType!.title,
    selectedJobStages: stages,
    selectedReminders: action.jobType!.reminders,
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
