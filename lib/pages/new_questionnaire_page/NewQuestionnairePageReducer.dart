import 'package:dandylight/models/Questionnaire.dart';
import 'package:redux/redux.dart';
import 'NewQuestionnaireActions.dart';
import 'NewQuestionnairePageState.dart';

final newQuestionnaireReducer = combineReducers<NewQuestionnairePageState>([
  TypedReducer<NewQuestionnairePageState, SetQuestionnaireAction>(_setContracts),
  TypedReducer<NewQuestionnairePageState, SetQuestionnaireNameAction>(_setContractName),
  TypedReducer<NewQuestionnairePageState, ClearNewQuestionnaireState>(_clearState),
  TypedReducer<NewQuestionnairePageState, SetProfileForNewQuestionnaireAction>(_setProfile),
  TypedReducer<NewQuestionnairePageState, DeleteQuestionAction>(_deleteQuestion),
  TypedReducer<NewQuestionnairePageState, SetMessageToClientAction>(_setMessage),
]);

NewQuestionnairePageState _setMessage(NewQuestionnairePageState previousState, SetMessageToClientAction action){
  Questionnaire questionnaire = action.pageState.questionnaire;
  questionnaire.message = action.message;
  return previousState.copyWith(
    questionnaire: questionnaire,
  );
}

NewQuestionnairePageState _deleteQuestion(NewQuestionnairePageState previousState, DeleteQuestionAction action) {
  previousState.questionnaire.questions.removeWhere((question) => question.id == previousState.questionnaire.questions.elementAt(action.questionIndex).id);
  return previousState.copyWith(
    questionnaire: previousState.questionnaire,
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

NewQuestionnairePageState _setContracts(NewQuestionnairePageState previousState, SetQuestionnaireAction action){
  return previousState.copyWith(
    questionnaire: action.questionnaire
  );
}
