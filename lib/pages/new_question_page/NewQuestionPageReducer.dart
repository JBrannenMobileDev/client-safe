import 'package:redux/redux.dart';
import 'NewQuestionnaireActions.dart';
import 'NewQuestionPageState.dart';

final newQuestionReducer = combineReducers<NewQuestionPageState>([
  TypedReducer<NewQuestionPageState, SetQuestionnaireAction>(_setQuestionnaire),
  TypedReducer<NewQuestionPageState, SetQuestionnaireNameAction>(_setContractName),
  TypedReducer<NewQuestionPageState, ClearNewQuestionnaireState>(_clearState),
  TypedReducer<NewQuestionPageState, SetProfileForNewQuestionnaireAction>(_setProfile),
  TypedReducer<NewQuestionPageState, SetMessageToClientAction>(_setMessage),
]);

NewQuestionPageState _setMessage(NewQuestionPageState previousState, SetMessageToClientAction action){
  return previousState.copyWith(
    message: action.message,
  );
}

NewQuestionPageState _setProfile(NewQuestionPageState previousState, SetProfileForNewQuestionnaireAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

NewQuestionPageState _clearState(NewQuestionPageState previousState, ClearNewQuestionnaireState action){
  NewQuestionPageState pageState = NewQuestionPageState.initial();
  return pageState.copyWith(
    isNew: action.isNew,
    newFromName: action.questionnaireName,
  );
}

NewQuestionPageState _setContractName(NewQuestionPageState previousState, SetQuestionnaireNameAction action){
  return previousState.copyWith(
      questionnaireName: action.questionnaireName,
  );
}

NewQuestionPageState _setQuestionnaire(NewQuestionPageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire,
    message: action.questionnaire.message,
    questionnaireName: action.questionnaire.title,
  );
}
