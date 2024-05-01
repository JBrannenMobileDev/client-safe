import 'package:redux/redux.dart';

import 'AnswerQuestionnaireActions.dart';
import 'AnswerQuestionnairePageState.dart';

final answerQuestionnaireReducer = combineReducers<AnswerQuestionnairePageState>([
  TypedReducer<AnswerQuestionnairePageState, SetQuestionnaireAction>(_setQuestionnaire),
  TypedReducer<AnswerQuestionnairePageState, SetProfileForAnswerAction>(_setProfile),
  TypedReducer<AnswerQuestionnairePageState, ClearAnswerState>(_clearState),
]);

AnswerQuestionnairePageState _clearState(AnswerQuestionnairePageState previousState, ClearAnswerState action){
  AnswerQuestionnairePageState newState = AnswerQuestionnairePageState.initial();
  return newState.copyWith(
    isPreview: action.isPreview,
    userId: action.userId,
    jobId: action.jobId,
  );
}

AnswerQuestionnairePageState _setQuestionnaire(AnswerQuestionnairePageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire,
  );
}

AnswerQuestionnairePageState _setProfile(AnswerQuestionnairePageState previousState, SetProfileForAnswerAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}
