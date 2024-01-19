
import 'package:dandylight/models/Questionnaire.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../models/Contract.dart';
import '../../models/Profile.dart';
import 'NewQuestionnairePageState.dart';

class SetQuestionnaireAction{
  final NewQuestionnairePageState pageState;
  final Questionnaire questionnaire;
  SetQuestionnaireAction(this.pageState, this.questionnaire);
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
  SaveQuestionnaireAction(this.pageState, this.jobDocumentId);
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

class SetProfileForNewQuestionnaireAction {
  final NewQuestionnairePageState pageState;
  final Profile profile;
  SetProfileForNewQuestionnaireAction(this.pageState, this.profile);
}

