
import 'package:dandylight/models/Questionnaire.dart';
import '../../models/Profile.dart';
import '../../models/Question.dart';
import 'AnswerQuestionnairePageState.dart';

class SetQuestionnaireAction{
  final AnswerQuestionnairePageState pageState;
  final Questionnaire questionnaire;
  SetQuestionnaireAction(this.pageState, this.questionnaire);
}

class ClearAnswerState {
  final AnswerQuestionnairePageState pageState;
  final bool isNew;
  final String questionnaireName;
  ClearAnswerState(this.pageState, this.isNew, this.questionnaireName);
}

class FetchProfileForAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final Questionnaire questionnaire;
  FetchProfileForAnswerAction(this.pageState, this.questionnaire);
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

class SaveLongFormAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveLongFormAnswerAction(this.pageState, this.answer, this.question);
}

