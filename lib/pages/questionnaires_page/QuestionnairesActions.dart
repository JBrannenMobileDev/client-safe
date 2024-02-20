
import '../../models/Contract.dart';
import '../../models/Questionnaire.dart';
import 'QuestionnairesPageState.dart';

class FetchQuestionnairesAction{
  final QuestionnairesPageState pageState;
  FetchQuestionnairesAction(this.pageState);
}

class SetQuestionnairesAction{
  final QuestionnairesPageState pageState;
  final List<Questionnaire> questionnaire;
  SetQuestionnairesAction(this.pageState, this.questionnaire);
}

class SaveQuestionnaireToJobAction {
  final QuestionnairesPageState pageState;
  final Questionnaire questionnaire;
  final String jobDocumentId;
  SaveQuestionnaireToJobAction(this.pageState, this.questionnaire, this.jobDocumentId);
}

class CancelSubscriptionsAction {
  final QuestionnairesPageState pageState;
  CancelSubscriptionsAction(this.pageState);
}

