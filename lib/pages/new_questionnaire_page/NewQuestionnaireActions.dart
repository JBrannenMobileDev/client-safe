
import 'package:dandylight/models/Questionnaire.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'NewQuestionnairePageState.dart';

class SetQuestionnaireAction{
  final NewQuestionnairePageState pageState;
  final Questionnaire questionnaire;
  final String jobDocumentId;
  SetQuestionnaireAction(this.pageState, this.questionnaire, this.jobDocumentId);
}

class ClearNewQuestionnaireState {
  final NewQuestionnairePageState pageState;
  final bool isNew;
  final String questionnaireName;
  ClearNewQuestionnaireState(this.pageState, this.isNew, this.questionnaireName);
}

class SaveQuestionnaireAction{
  final NewQuestionnairePageState pageState;
  final String jobDocumentId;
  final List<Question> questions;
  SaveQuestionnaireAction(this.pageState, this.jobDocumentId, this.questions);
}

class SetQuestionnaireNameAction {
  final NewQuestionnairePageState pageState;
  final String questionnaireName;
  SetQuestionnaireNameAction(this.pageState, this.questionnaireName);
}

class DeleteQuestionnaireAction {
  final NewQuestionnairePageState pageState;
  DeleteQuestionnaireAction(this.pageState);
}

class FetchProfileForNewQuestionnaireAction {
  final NewQuestionnairePageState pageState;
  FetchProfileForNewQuestionnaireAction(this.pageState);
}

class SetMessageToClientAction {
  final NewQuestionnairePageState pageState;
  final String message;
  SetMessageToClientAction(this.pageState, this.message);
}

class OnAddOrUpdateQuestionSelected {
  final NewQuestionnairePageState pageState;
  final Question question;
  OnAddOrUpdateQuestionSelected(this.pageState, this.question);
}

class SetProfileForNewQuestionnaireAction {
  final NewQuestionnairePageState pageState;
  final Profile profile;
  SetProfileForNewQuestionnaireAction(this.pageState, this.profile);
}

