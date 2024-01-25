import 'package:dandylight/models/Questionnaire.dart';
import 'package:redux/redux.dart';
import 'NewQuestionnaireActions.dart';
import 'NewQuestionnairePageState.dart';

final newQuestionnaireReducer = combineReducers<NewQuestionnairePageState>([
  TypedReducer<NewQuestionnairePageState, SetQuestionnaireAction>(_setQuestionnaire),
  TypedReducer<NewQuestionnairePageState, SetQuestionnaireNameAction>(_setContractName),
  TypedReducer<NewQuestionnairePageState, ClearNewQuestionnaireState>(_clearState),
  TypedReducer<NewQuestionnairePageState, SetProfileForNewQuestionnaireAction>(_setProfile),
  TypedReducer<NewQuestionnairePageState, SetMessageToClientAction>(_setMessage),
]);

NewQuestionnairePageState _setMessage(NewQuestionnairePageState previousState, SetMessageToClientAction action){
  return previousState.copyWith(
    message: action.message,
  );
}

NewQuestionnairePageState _setProfile(NewQuestionnairePageState previousState, SetProfileForNewQuestionnaireAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

NewQuestionnairePageState _clearState(NewQuestionnairePageState previousState, ClearNewQuestionnaireState action){
  NewQuestionnairePageState pageState = NewQuestionnairePageState.initial();
  return pageState.copyWith(
    isNew: action.isNew,
    newFromName: action.questionnaireName,
  );
}

NewQuestionnairePageState _setContractName(NewQuestionnairePageState previousState, SetQuestionnaireNameAction action){
  return previousState.copyWith(
      questionnaireName: action.questionnaireName,
  );
}

NewQuestionnairePageState _setQuestionnaire(NewQuestionnairePageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire,
    message: action.questionnaire.message,
    questionnaireName: action.questionnaire.title,
  );
}
