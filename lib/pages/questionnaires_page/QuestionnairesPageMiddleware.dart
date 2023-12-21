import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'QuestionnairesActions.dart';

class QuestionnairesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchQuestionnairesAction){
      fetchContracts(store, next);
    }
    if(action is SaveQuestionnaireToJobAction) {
      saveContractToJob(store, action);
    }
  }
update this page to questionnaires then update all the New Questionnair classes.
  void saveContractToJob(Store<AppState> store, SaveQuestionnaireToJobAction action) async {
    Contract contract = action.contract;
    contract.photographerSignedDate = DateTime.now();
    contract.signedByPhotographer = true;
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    contract.photographerSignature = '${profile.firstName} ${profile.lastName}';
    contract.signedByClient = false;
    contract.clientSignature = '';
    Job job = await JobDao.getJobById(action.jobDocumentId);
    job.proposal.contract = contract;
    await JobDao.update(job);
    EventSender().sendEvent(eventName: EventNames.CONTRACT_ADDED_TO_JOB);
    store.dispatch(SetJobInfoWithJobDocumentId(store.state.jobDetailsPageState, job.documentId));
  }

  void fetchContracts(Store<AppState> store, NextDispatcher next) async{
      List<Contract> contracts = await ContractDao.getAll();
      List<Contract> contractTemplates = await ContractTemplateDao.getAll();
      next(SetQuestionnairesAction(store.state.questionnairesPageState, contracts, contractTemplates));

      (await ContractDao.getContractsStream()).listen((snapshots) async {
        List<Contract> contractsToUpdate = [];
        for(RecordSnapshot reminderSnapshot in snapshots) {
          contractsToUpdate.add(Contract.fromMap(reminderSnapshot.value));
        }
        store.dispatch(SetQuestionnairesAction(store.state.questionnairesPageState, contractsToUpdate, await ContractTemplateDao.getAll()));
      });
  }
}