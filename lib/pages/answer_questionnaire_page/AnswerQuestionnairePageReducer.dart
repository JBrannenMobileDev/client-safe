import 'package:redux/redux.dart';

import 'AnswerQuestionnaireActions.dart';
import 'AnswerQuestionnairePageState.dart';

final answerQuestionnaireReducer = combineReducers<AnswerQuestionnairePageState>([
  TypedReducer<AnswerQuestionnairePageState, SetQuestionnaireAction>(_setQuestionnaire),
]);

AnswerQuestionnairePageState _setQuestionnaire(AnswerQuestionnairePageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire,
  );
}
