
import 'package:dandylight/models/Questionnaire.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'AnswerQuestionnairePageState.dart';

class SetQuestionnaireAction{
  final AnswerQuestionnairePageState pageState;
  final Questionnaire questionnaire;
  final String jobDocumentId;
  SetQuestionnaireAction(this.pageState, this.questionnaire, this.jobDocumentId);
}

class ClearNewQuestionnaireState {
  final AnswerQuestionnairePageState pageState;
  final bool isNew;
  final String questionnaireName;
  ClearNewQuestionnaireState(this.pageState, this.isNew, this.questionnaireName);
}

class SaveQuestionnaireAction{
  final AnswerQuestionnairePageState pageState;
  final String jobDocumentId;
  final List<Question> questions;
  final bool isNew;
  SaveQuestionnaireAction(this.pageState, this.jobDocumentId, this.questions, this.isNew);
}

class SetQuestionnaireNameAction {
  final AnswerQuestionnairePageState pageState;
  final String questionnaireName;
  SetQuestionnaireNameAction(this.pageState, this.questionnaireName);
}

class DeleteQuestionnaireAction {
  final AnswerQuestionnairePageState pageState;
  DeleteQuestionnaireAction(this.pageState);
}

class FetchProfileForNewQuestionnaireAction {
  final AnswerQuestionnairePageState pageState;
  FetchProfileForNewQuestionnaireAction(this.pageState);
}

class SetMessageToClientAction {
  final AnswerQuestionnairePageState pageState;
  final String message;
  SetMessageToClientAction(this.pageState, this.message);
}

class OnAddOrUpdateQuestionSelected {
  final AnswerQuestionnairePageState pageState;
  final Question question;
  OnAddOrUpdateQuestionSelected(this.pageState, this.question);
}

class SetProfileForNewQuestionnaireAction {
  final AnswerQuestionnairePageState pageState;
  final Profile profile;
  SetProfileForNewQuestionnaireAction(this.pageState, this.profile);
}

