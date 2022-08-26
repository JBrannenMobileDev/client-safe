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
  TypedReducer<NewJobTypePageState, UpdateFlatRateTextAction>(_setFlatRate),
  TypedReducer<NewJobTypePageState, UpdateCheckAllAction>(_setCheckAllChecked),
]);

NewJobTypePageState _setFlatRate(NewJobTypePageState previousState, UpdateFlatRateTextAction action) {
  String resultCost = action.flatRateText.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = double.parse(resultCost);
  doubleCost = doubleCost * 10;
  return previousState.copyWith(
    flatRate: doubleCost,
  );
}

NewJobTypePageState _setCheckAllChecked(NewJobTypePageState previousState, UpdateCheckAllAction action) {
  List<JobStage> selectedJobStagesNew = [];
  if(action.isChecked) {
    selectedJobStagesNew.addAll(previousState.allJobStages);
  }
  return previousState.copyWith(
    checkAll: action.isChecked,
    selectedJobStages: selectedJobStagesNew,
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
  List<ReminderDandyLight> reminders = previousState.selectedReminders;
  if(!reminders.contains(action.selectedReminder)) {
    reminders.add(action.selectedReminder);
  }
  return previousState.copyWith(
    selectedReminders: reminders,
  );
}

NewJobTypePageState _loadExistingJobType(NewJobTypePageState previousState, LoadExistingJobTypeData action){
  return previousState.copyWith(
    id: action.jobType.id,
    documentId: action.jobType.documentId,
    title: action.jobType.title,
    flatRate: action.jobType.flatRate.toDouble(),
    selectedJobStages: action.jobType.stages,
    selectedReminders: action.jobType.reminders,
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
