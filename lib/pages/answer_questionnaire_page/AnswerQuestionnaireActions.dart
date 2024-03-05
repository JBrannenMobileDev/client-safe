
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

class ClearAnswerState {
  final AnswerQuestionnairePageState pageState;
  final bool isNew;
  final String questionnaireName;
  ClearAnswerState(this.pageState, this.isNew, this.questionnaireName);
}

class FetchProfileForAnswerAction {
  final AnswerQuestionnairePageState pageState;
  FetchProfileForAnswerAction(this.pageState);
}

class SetProfileForAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final Profile profile;
  SetProfileForAnswerAction(this.pageState, this.profile);
}

class SaveShortFormAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveShortFormAnswerAction(this.pageState, this.answer, this.question);
}

