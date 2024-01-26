import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:redux/redux.dart';
import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchQuestionnairesAction){
      fetchQuestionnaires(store, next);
    }
    if(action is SaveQuestionnaireToJobAction) {
      saveQuestionnaireToJob(store, action);
    }
  }

  void saveQuestionnaireToJob(Store<AppState> store, SaveQuestionnaireToJobAction action) async {
    Questionnaire questionnaire = action.questionnaire;
    Job job = await JobDao.getJobById(action.jobDocumentId);
    job.proposal.questionnaires.add(questionnaire);
    await JobDao.update(job);
    EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_ADDED_TO_JOB);
    store.dispatch(SetJobInfoWithJobDocumentId(store.state.jobDetailsPageState, job.documentId));
  }

  void fetchQuestionnaires(Store<AppState> store, NextDispatcher next) async{
      List<Questionnaire> questionnaires = (await QuestionnairesDao.getAll()) ?? [];
      store.dispatch(SetQuestionnairesAction(store.state.questionnairesPageState, questionnaires));
  }
}