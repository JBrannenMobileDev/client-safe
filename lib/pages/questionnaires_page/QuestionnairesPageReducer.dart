import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:redux/redux.dart';

import 'QuestionnairesActions.dart';

final questionnairesReducer = combineReducers<QuestionnairesPageState>([
  TypedReducer<QuestionnairesPageState, SetQuestionnairesAction>(_setContracts),
]);

QuestionnairesPageState _setContracts(QuestionnairesPageState previousState, SetQuestionnairesAction action){
  return previousState.copyWith(
    questionnaires: action.questionnaire,
  );
}
