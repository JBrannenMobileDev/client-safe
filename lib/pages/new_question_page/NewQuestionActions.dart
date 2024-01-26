
import 'package:dandylight/models/Questionnaire.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'NewQuestionPageState.dart';

class SetQuestionnaireAction{
  final NewQuestionPageState pageState;
  final Questionnaire questionnaire;
  final String jobDocumentId;
  SetQuestionnaireAction(this.pageState, this.questionnaire, this.jobDocumentId);
}

class ClearNewQuestionnaireState {
  final NewQuestionPageState pageState;
  final bool isNew;
  final String questionnaireName;
  ClearNewQuestionnaireState(this.pageState, this.isNew, this.questionnaireName);
}

class SaveQuestionnaireAction{
  final NewQuestionPageState pageState;
  final String jobDocumentId;
  final List<Question> questions;
  SaveQuestionnaireAction(this.pageState, this.jobDocumentId, this.questions);
}

class SetQuestionnaireNameAction {
  final NewQuestionPageState pageState;
  final String questionnaireName;
  SetQuestionnaireNameAction(this.pageState, this.questionnaireName);
}

class DeleteQuestionnaireAction {
  final NewQuestionPageState pageState;
  DeleteQuestionnaireAction(this.pageState);
}

class FetchProfileForNewQuestionnaireAction {
  final NewQuestionPageState pageState;
  FetchProfileForNewQuestionnaireAction(this.pageState);
}

class SetMessageToClientAction {
  final NewQuestionPageState pageState;
  final String message;
  SetMessageToClientAction(this.pageState, this.message);
}

class SetProfileForNewQuestionnaireAction {
  final NewQuestionPageState pageState;
  final Profile profile;
  SetProfileForNewQuestionnaireAction(this.pageState, this.profile);
}

