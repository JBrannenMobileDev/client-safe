import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:share_plus/share_plus.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../utils/UUID.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageMiddleware extends MiddlewareClass<AppState> {
  StreamSubscription? subscription;

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
    if(action is CreateNewJoblessQuestionnaireAction) {
      createNewJoblessQuestionnaire(store, action);
    }
  }

  void createNewJoblessQuestionnaire(Store<AppState> store, CreateNewJoblessQuestionnaireAction action) async {
    Questionnaire questionnaire = action.questionnaire;
    questionnaire.isTemplate = false;
    questionnaire.clientName = action.name;
    questionnaire.dateCreated = DateTime.now();
    questionnaire.documentId = null;

    Questionnaire questionnaireWithId = await QuestionnairesDao.insert(questionnaire);
    //Figure out how to send from here.
    String questionnaireLink = 'Questionnaire link:\nhttps://DandyLight.com/questionnaire/${UidUtil().getUid()}+${questionnaireWithId.documentId}';
    Share.share('${action.message}\n\n\n$questionnaireLink');
    print(questionnaireLink);
  }

  void saveQuestionnaireToJob(Store<AppState> store, SaveQuestionnaireToJobAction action) async {
    Questionnaire questionnaire = action.questionnaire;
    questionnaire.jobDocumentId = action.jobDocumentId;
    questionnaire.documentId = Uuid().generateV4();
    Job? job = await JobDao.getJobById(action.jobDocumentId);
    questionnaire.clientName = job?.clientName ?? '';
    job!.proposal!.questionnaires!.add(questionnaire);
    try{
      await JobDao.update(job);
    } catch(e) {
      print(e);
    }
    EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_ADDED_TO_JOB);
    store.dispatch(SetJobInfo(store.state.jobDetailsPageState, action.jobDocumentId));

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.addQuestionnaireToJob) {
      profile.progress.addQuestionnaireToJob = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.ADD_QUESTIONNAIRE_TO_JOB,
      });
    }
  }

  void fetchQuestionnaires(Store<AppState> store, NextDispatcher next) async{
      var questionnaireSubscription = (await QuestionnairesDao.getQuestionnairesStream());
      subscription = questionnaireSubscription.listen((snapshots) async {
        List<Questionnaire> questionnaires = [];
        List<Questionnaire> templateQuestionnaires = [];
        for(RecordSnapshot record in snapshots) {
          questionnaires.add(Questionnaire.fromMap(record.value as Map<String,dynamic>));
        }
        for(Questionnaire questionnaire in questionnaires) {
          if(questionnaire.isTemplate ?? false) templateQuestionnaires.add(questionnaire);
        }

        store.dispatch(SetQuestionnairesAction(store.state.questionnairesPageState!, templateQuestionnaires));
      });

      store.dispatch(SetActiveJobsToQuestionnairesAction(store.state.questionnairesPageState!, store.state.dashboardPageState!.activeJobs!));
  }
}