import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:uuid/v4.dart';

import '../../models/Contract.dart';
import '../../models/Job.dart';
import '../../models/JobStage.dart';
import '../../models/Progress.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'ContractEditActions.dart';

class ContractEditPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveContractAction){
      saveContract(store, action, next);
    }
    if(action is DeleteContractAction){
      deleteContract(store, action, next);
    }
    if(action is FetchProfileForContractEditAction) {
      fetchProfile(store, action, next);
    }
  }

  void fetchProfile(Store<AppState> store, FetchProfileForContractEditAction action, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileForContractEditAction(store.state.contractEditPageState, profile));
  }

  void deleteContract(Store<AppState> store, DeleteContractAction action, NextDispatcher next) async{
    if(action.pageState!.contract != null) {
      await ContractDao.delete(action.pageState!.contract!.documentId);
      await ContractDao.delete(action.pageState!.contract!.documentId);
    }
  }

  void saveContract(Store<AppState> store, SaveContractAction action, NextDispatcher next) async{
    Contract? contract;
    if(action.jobDocumentId != null && action.jobDocumentId!.isNotEmpty) {
      Job? job = await JobDao.getJobById(action.jobDocumentId);
      if(job != null && (job.proposal?.contracts?.isNotEmpty ?? false)){
        Contract? contract = Contract.fromMap((job.proposal!.contracts!.where((item) => item.documentId == action.pageState!.contract!.documentId).first).toMap());
        contract.jsonTerms = jsonEncode(action.quillContract!.toDelta().toJson());
        contract.terms = action.quillContract!.toPlainText();
        contract.contractName = action.pageState!.contractName;
        contract.clientSignedDate = null;
        contract.clientSignature = "";
        contract.photographerSignedDate = DateTime.now();
        contract.isVoid = false;
        contract.firstSharedDate = DateTime.now();
        final index = job.proposal!.contracts!.indexWhere((item) => item.documentId == contract.documentId);

        if(contract.signedByClient ?? false) {
          contract.signedByClient = false;
          contract.documentId = const UuidV4().generate();
          job.proposal!.contracts!.elementAt(index).isVoid = true;
          job.proposal!.contracts!.add(contract);
        } else {
          contract.signedByClient = false;
          job.proposal!.contracts![index] = contract;
        }

        await JobDao.update(job);

        Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
        if(profile != null && !profile.progress.addContractToJob) {
          profile.progress.addContractToJob = true;
          await ProfileDao.update(profile);
          EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
            EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.ADD_CONTRACT_TO_JOB,
          });
        }
        store.dispatch(LoadJobsAction(store.state.dashboardPageState));

        List<JobStage> completedStages = job.completedStages!;
        bool isContractSignedChecked = false;
        completedStages.forEach((stage) {
          if(stage.stage == JobStage.STAGE_4_PROPOSAL_SIGNED) isContractSignedChecked = true;
        });

        if(isContractSignedChecked) {
          List<JobStage>? stages = job.sessionType!.stages;
          int index = -1;
          for(int i = 0; i < stages!.length; i++) {
            if(stages.elementAt(i).stage == JobStage.STAGE_4_PROPOSAL_SIGNED) {
              index = i;
            }
          }
          store.dispatch(UndoStageAction(store.state.jobDetailsPageState!, job, index));
        }
        store.dispatch(SetJobInfo(store.state.jobDetailsPageState!, job.documentId!));
      }
    } else {
      if(action.pageState!.contract == null) {
        contract = Contract(
          contractName: action.pageState!.contractName!,
          terms: action.quillContract!.toPlainText(),
          jsonTerms: jsonEncode(action.quillContract!.toDelta().toJson()),
          signedByPhotographer: true,
          signedByClient: false,
        );
        if(action.pageState!.isNew!) {
          contract.documentId = null;
        }
      } else {
        contract = action.pageState!.contract!;
        if(action.pageState!.isNew!) {
          contract.documentId = null;
        }
        contract.contractName = action.pageState!.contractName;
        contract.signedByClient = false;
        contract.signedByPhotographer = true;
        contract.terms = action.quillContract!.toPlainText();
        contract.jsonTerms = jsonEncode(action.quillContract!.toDelta().toJson());
      }
      await ContractDao.insertOrUpdate(contract);
      if(action.pageState!.isNew!) {
        EventSender().sendEvent(eventName: EventNames.CONTRACT_CREATED, properties: {
          EventNames.CONTRACT_CREATED_FROM_PARAM : action.pageState!.newFromName!,
        });

        Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
        if(profile != null && !profile.progress.createContract) {
          profile.progress.createContract = true;
          await ProfileDao.update(profile);
          store.dispatch(LoadJobsAction(store.state.dashboardPageState));
          EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
            EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.CREATE_CONTRACT,
          });
        }
      }
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