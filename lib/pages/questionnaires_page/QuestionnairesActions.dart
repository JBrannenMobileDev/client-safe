
import '../../models/Contract.dart';
import '../../models/Job.dart';
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

class SetActiveJobsToQuestionnairesAction {
  final QuestionnairesPageState pageState;
  final List<Job> activeJobs;
  SetActiveJobsToQuestionnairesAction(this.pageState, this.activeJobs);
}

class UpdateShareMessageAction {
  final QuestionnairesPageState pageState;
  final String shareMessage;
  UpdateShareMessageAction(this.pageState, this.shareMessage);
}

