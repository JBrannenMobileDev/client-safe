
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
  ClearAnswerState(this.pageState);
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

class SaveFirstNameAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveFirstNameAnswerAction(this.pageState, this.answer, this.question);
}

class SaveLastNameAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveLastNameAnswerAction(this.pageState, this.answer, this.question);
}

class SavePhoneNumberAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SavePhoneNumberAnswerAction(this.pageState, this.answer, this.question);
}

class SaveEmailAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveEmailAnswerAction(this.pageState, this.answer, this.question);
}

class SaveInstagramNameAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveInstagramNameAnswerAction(this.pageState, this.answer, this.question);
}

class SaveNumberAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveNumberAnswerAction(this.pageState, this.answer, this.question);
}

class SaveYesNoAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final bool answer;
  final Question question;
  SaveYesNoAnswerAction(this.pageState, this.answer, this.question);
}

class SaveCheckBoxSelectionAction {
  final AnswerQuestionnairePageState pageState;
  final int selectedIndex;
  final bool answer;
  final Question question;
  SaveCheckBoxSelectionAction(this.pageState, this.selectedIndex, this.answer, this.question);
}

class SaveRatingSelectionAction {
  final AnswerQuestionnairePageState pageState;
  final int selectedRating;
  final Question question;
  SaveRatingSelectionAction(this.pageState, this.selectedRating, this.question);
}

