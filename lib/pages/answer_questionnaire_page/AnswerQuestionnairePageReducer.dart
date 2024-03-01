import 'package:redux/redux.dart';

import 'AnswerQuestionnaireActions.dart';
import 'AnswerQuestionnairePageState.dart';

final answerQuestionnaireReducer = combineReducers<AnswerQuestionnairePageState>([
  TypedReducer<AnswerQuestionnairePageState, SetQuestionnaireAction>(_setQuestionnaire),
  TypedReducer<AnswerQuestionnairePageState, SetQuestionnaireNameAction>(_setContractName),
  TypedReducer<AnswerQuestionnairePageState, ClearNewQuestionnaireState>(_clearState),
  TypedReducer<AnswerQuestionnairePageState, SetProfileForNewQuestionnaireAction>(_setProfile),
  TypedReducer<AnswerQuestionnairePageState, SetMessageToClientAction>(_setMessage),
  TypedReducer<AnswerQuestionnairePageState, OnAddOrUpdateQuestionSelected>(_addOrUpdateQuestion),
]);

AnswerQuestionnairePageState _addOrUpdateQuestion(AnswerQuestionnairePageState previousState, OnAddOrUpdateQuestionSelected action){
  action.pageState.questionnaire.questions.where((question) => question.id == action.question.id).isNotEmpty ? action.pageState.questionnaire.questions[action.pageState.questionnaire.questions.indexWhere((question) => question.id == action.question.id)] = action.question 
      : action.pageState.questionnaire.questions.add(action.question);
  return previousState.copyWith(
    questionnaire: action.pageState.questionnaire,
  );
}

AnswerQuestionnairePageState _setMessage(AnswerQuestionnairePageState previousState, SetMessageToClientAction action){
  return previousState.copyWith(
    message: action.message,
  );
}

AnswerQuestionnairePageState _setProfile(AnswerQuestionnairePageState previousState, SetProfileForNewQuestionnaireAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

AnswerQuestionnairePageState _clearState(AnswerQuestionnairePageState previousState, ClearNewQuestionnaireState action){
  AnswerQuestionnairePageState pageState = AnswerQuestionnairePageState.initial();
  return pageState.copyWith(
    isNew: action.isNew,
    newFromName: action.questionnaireName,
  );
}

AnswerQuestionnairePageState _setContractName(AnswerQuestionnairePageState previousState, SetQuestionnaireNameAction action){
  return previousState.copyWith(
      questionnaireName: action.questionnaireName,
  );
}

AnswerQuestionnairePageState _setQuestionnaire(AnswerQuestionnairePageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire,
    message: action.questionnaire.message,
    questionnaireName: action.questionnaire.title,
  );
}
