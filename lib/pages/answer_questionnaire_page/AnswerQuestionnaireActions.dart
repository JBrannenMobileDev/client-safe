
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
  final bool isPreview;
  final String? userId;
  final String? jobId;
  final bool isDirectSend;
  final bool? isAdmin;
  ClearAnswerState(this.pageState, this.isPreview, this.userId, this.jobId, this.isDirectSend, this.isAdmin);
}

class FetchProfileForAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final Questionnaire? questionnaire;
  final bool isPreview;
  final String? userId;
  final String? jobId;
  final String? questionnaireId;
  final Profile? profile;
  final bool? isAdmin;
  FetchProfileForAnswerAction(this.pageState, this.questionnaire, this.isPreview, this.userId, this.jobId, this.profile, this.questionnaireId, this.isAdmin);
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

class SaveDateSelectionAction {
  final AnswerQuestionnairePageState pageState;
  final DateTime? date;
  final Question question;
  SaveDateSelectionAction(this.pageState, this.date, this.question);
}

class SaveAddressAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveAddressAnswerAction(this.pageState, this.answer, this.question);
}

class SaveAddressLine2AnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveAddressLine2AnswerAction(this.pageState, this.answer, this.question);
}

class SaveCityTownAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveCityTownAnswerAction(this.pageState, this.answer, this.question);
}

class SaveStateRegionAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveStateRegionAnswerAction(this.pageState, this.answer, this.question);
}

class SaveZipAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveZipAnswerAction(this.pageState, this.answer, this.question);
}

class SaveCountryAnswerAction {
  final AnswerQuestionnairePageState pageState;
  final String answer;
  final Question question;
  SaveCountryAnswerAction(this.pageState, this.answer, this.question);
}

class SubmitQuestionnaireAction {
  final AnswerQuestionnairePageState pageState;
  SubmitQuestionnaireAction(this.pageState);
}

class SaveQuestionnaireProgressAction {
  final AnswerQuestionnairePageState pageState;
  SaveQuestionnaireProgressAction(this.pageState);
}

