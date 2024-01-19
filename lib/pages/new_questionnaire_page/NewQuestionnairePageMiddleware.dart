import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../models/Contract.dart';
import '../../models/Job.dart';
import '../../models/JobStage.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'NewQuestionnaireActions.dart';

class ContractEditPageMiddleware extends MiddlewareClass<AppState> {

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
    next(SetProfileForNewQuestionnaireAction(store.state.newQuestionnairePageState, profile));
  }

  void deleteQuestionnaire(Store<AppState> store, DeleteQuestionnaireAction action, NextDispatcher next) async{
    if(action.pageState.questionnaire != null) {
      await ContractDao.delete(action.pageState.questionnaire.documentId);
    }
  }

  void saveQuestionnaire(Store<AppState> store, SaveQuestionnaireAction action, NextDispatcher next) async{
    // Contract contract = null;
    // if(action.jobDocumentId != null && action.jobDocumentId.isNotEmpty) {
    //   Job job = await JobDao.getJobById(action.jobDocumentId);
    //   Contract contract = job.proposal.contract;
    //   contract.jsonTerms = jsonEncode(action.quillContract.toDelta().toJson());
    //   contract.terms = action.quillContract.toPlainText();
    //   contract.contractName = action.pageState.contractName;
    //   contract.signedByClient = false;
    //   contract.clientSignedDate = null;
    //   contract.clientSignature = "";
    //   contract.photographerSignedDate = DateTime.now();
    //   job.proposal.contract = contract;
    //   await JobDao.update(job);
    //
    //   List<JobStage> completedStages = job.completedStages;
    //   bool isContractSignedChecked = false;
    //   completedStages.forEach((stage) {
    //     if(stage.stage == JobStage.STAGE_4_PROPOSAL_SIGNED) isContractSignedChecked = true;
    //   });
    //
    //   if(isContractSignedChecked) {
    //     List<JobStage> stages = job.type.stages;
    //     int index = -1;
    //     for(int i = 0; i < stages.length; i++) {
    //       if(stages.elementAt(i).stage == JobStage.STAGE_4_PROPOSAL_SIGNED) {
    //         index = i;
    //       }
    //     }
    //     store.dispatch(UndoStageAction(store.state.jobDetailsPageState, job, index));
    //   }
    //   store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job.documentId));
    // } else {
    //   if(action.pageState.contract == null) {
    //     contract = Contract(
    //       contractName: action.pageState.contractName,
    //       terms: action.quillContract.toPlainText(),
    //       jsonTerms: jsonEncode(action.quillContract.toDelta().toJson()),
    //       signedByPhotographer: true,
    //       signedByClient: false,
    //     );
    //     if(action.pageState.isNew) {
    //       contract.documentId = null;
    //     }
    //   } else {
    //     contract = action.pageState.contract;
    //     if(action.pageState.isNew) {
    //       contract.documentId = null;
    //     }
    //     contract.contractName = action.pageState.contractName;
    //     contract.signedByClient = false;
    //     contract.signedByPhotographer = true;
    //     contract.terms = action.quillContract.toPlainText();
    //     contract.jsonTerms = jsonEncode(action.quillContract.toDelta().toJson());
    //   }
    //   await ContractDao.insertOrUpdate(contract);
    //   if(action.pageState.isNew) {
    //     EventSender().sendEvent(eventName: EventNames.CONTRACT_CREATED, properties: {
    //       EventNames.CONTRACT_CREATED_FROM_PARAM : action.pageState.newFromName,
    //     });
    //   }
    // }
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