import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import '../../models/Job.dart';
import '../../utils/UUID.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription subscription;

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchQuestionnairesAction){
      fetchQuestionnaires(store, next);
    }
    if(action is SaveQuestionnaireToJobAction) {
      saveQuestionnaireToJob(store, action);
    }
    if(action is CancelSubscriptionsAction) {
      subscription?.cancel();
    }
  }

  void saveQuestionnaireToJob(Store<AppState> store, SaveQuestionnaireToJobAction action) async {
    Questionnaire questionnaire = action.questionnaire;
    questionnaire.jobDocumentId = action.jobDocumentId;
    questionnaire.documentId = Uuid().generateV4();
    Job job = await JobDao.getJobById(action.jobDocumentId);
    job.proposal.questionnaires.add(questionnaire);
    try{
      await JobDao.update(job);
    } catch(e) {
      print(e);
    }
    EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_ADDED_TO_JOB);
    store.dispatch(SetJobInfo(store.state.jobDetailsPageState, action.jobDocumentId));
  }

  void fetchQuestionnaires(Store<AppState> store, NextDispatcher next) async{
      var questionnaireSubscription = (await QuestionnairesDao.getQuestionnairesStream());
      subscription = questionnaireSubscription.listen((snapshots) async {
        List<Questionnaire> questionnaires = [];
        for(RecordSnapshot record in snapshots) {
          questionnaires.add(Questionnaire.fromMap(record.value));
        }

        store.dispatch(SetQuestionnairesAction(store.state.questionnairesPageState, questionnaires));
      });

      store.dispatch(SetActiveJobsToQuestionnairesAction(store.state.questionnairesPageState, store.state.dashboardPageState.activeJobs));
  }
}