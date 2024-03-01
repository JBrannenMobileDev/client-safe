
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';
import '../questionnaires_page/QuestionnairesActions.dart';
import 'AnswerQuestionnaireActions.dart';

class AnswerQuestionnairePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveQuestionnaireAction){
      saveQuestionnaire(store, action, next);
    }
    if(action is DeleteQuestionnaireAction){
      deleteQuestionnaire(store, action, next);
    }
    if(action is FetchProfileForNewQuestionnaireAction) {
      fetchProfile(store, action, next);
    }
  }

  void fetchProfile(Store<AppState> store, FetchProfileForNewQuestionnaireAction action, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileForNewQuestionnaireAction(store.state.answerQuestionnairePageState, profile));
  }

  void deleteQuestionnaire(Store<AppState> store, DeleteQuestionnaireAction action, NextDispatcher next) async{
    if(action.pageState.questionnaire != null) {
      await QuestionnairesDao.delete(action.pageState.questionnaire.documentId);
      await QuestionnairesDao.delete(action.pageState.questionnaire.documentId);
      store.dispatch(FetchQuestionnairesAction(store.state.questionnairesPageState));
    }
  }

  void saveQuestionnaire(Store<AppState> store, SaveQuestionnaireAction action, NextDispatcher next) async{
    Questionnaire questionnaire = action.pageState.questionnaire ?? Questionnaire();
    questionnaire.questions = action.questions;
    questionnaire.title = action.pageState.questionnaireName;
    questionnaire.message = action.pageState.message;
    questionnaire.isComplete = false;

    if(action.jobDocumentId != null && action.jobDocumentId.isNotEmpty) {
      Job job = await JobDao.getJobById(action.jobDocumentId);
      Questionnaire questionnaireAlreadyExists = job.proposal.questionnaires.where((it) => it.documentId == questionnaire.documentId).first;
      if(questionnaireAlreadyExists == null) {
        job.proposal.questionnaires.add(questionnaire);
      } else {
        job.proposal.questionnaires[job.proposal.questionnaires.indexWhere((it) => it.documentId == questionnaireAlreadyExists.documentId)] = questionnaire;
      }
      await JobDao.update(job);
      store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job.documentId));
    } else {
      questionnaire = await QuestionnairesDao.insertOrUpdate(questionnaire);
    }

    if(action.pageState.isNew) {
      questionnaire = await QuestionnairesDao.insertOrUpdate(questionnaire);
    }

    store.dispatch(FetchQuestionnairesAction(store.state.questionnairesPageState));

    if(action.pageState.isNew) {
      EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_CREATED);
    }
  }

  /**
   * Only use this method to save a new Dandylight contract template.
   * NOT FOR USERS TO USE!
   * PLEASE KEEP COMMENTED OUT.
   */
  // void saveContract(Store<AppState> store, SaveContractAction action, NextDispatcher next) async{
  //   Contract contract = null;
  //   if(action.pageState.contract == null) {
  //     contract = Contract(
  //       contractName: action.pageState.contractName,
  //       terms: action.quillContract.toPlainText(),
  //       jsonTerms: jsonEncode(action.quillContract.toDelta().toJson()),
  //       signedByPhotographer: true,
  //
  //     );
  //   } else {
  //     contract = action.pageState.contract;
  //     contract.contractName = action.pageState.contractName;
  //     contract.terms = action.quillContract.toPlainText();
  //     contract.jsonTerms = jsonEncode(action.quillContract.toDelta().toJson());
  //   }
  //   await ContractTemplateDao.insertOrUpdate(contract);
  // }
}