import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:redux/redux.dart';

import 'QuestionnairesActions.dart';

final questionnairesReducer = combineReducers<QuestionnairesPageState>([
  TypedReducer<QuestionnairesPageState, SetQuestionnairesAction>(_setContracts),
  TypedReducer<QuestionnairesPageState, SetActiveJobsToQuestionnairesAction>(_setActiveJobs),
  TypedReducer<QuestionnairesPageState, UpdateShareMessageAction>(_setShareMessage),
]);

QuestionnairesPageState _setShareMessage(QuestionnairesPageState previousState, UpdateShareMessageAction action){
  return previousState.copyWith(
    shareMessage: action.shareMessage,
  );
}

QuestionnairesPageState _setActiveJobs(QuestionnairesPageState previousState, SetActiveJobsToQuestionnairesAction action){
  return previousState.copyWith(
    activeJobs: action.activeJobs,
  );
}

QuestionnairesPageState _setContracts(QuestionnairesPageState previousState, SetQuestionnairesAction action){
  return previousState.copyWith(
    questionnaires: action.questionnaire,
  );
}
