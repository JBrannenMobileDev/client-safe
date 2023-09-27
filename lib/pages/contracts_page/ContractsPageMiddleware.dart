import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import '../../models/Job.dart';
import '../job_details_page/JobDetailsActions.dart';
import 'ContractsActions.dart';

class ContractsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchContractsAction){
      fetchContracts(store, next);
    }
    if(action is SaveContractToJobAction) {
      saveContractToJob(store, action);
    }
  }

  void saveContractToJob(Store<AppState> store, SaveContractToJobAction action) async {
    Contract contract = action.contract;
    contract.photographerSignedDate = DateTime.now();
    contract.signedByPhotographer = true;

    //TODO populate contract with dynamic content.

    Job job = await JobDao.getJobById(action.jobDocumentId);
    job.contract = contract;
    await JobDao.update(job);
    store.dispatch(SetJobInfoWithJobDocumentId(store.state.jobDetailsPageState, job.documentId));
  }

  void fetchContracts(Store<AppState> store, NextDispatcher next) async{
      List<Contract> contracts = await ContractDao.getAll();
      List<Contract> contractTemplates = await ContractTemplateDao.getAll();
      next(SetContractsAction(store.state.contractsPageState, contracts, contractTemplates));

      (await ContractDao.getContractsStream()).listen((snapshots) async {
        List<Contract> contractsToUpdate = [];
        for(RecordSnapshot reminderSnapshot in snapshots) {
          contractsToUpdate.add(Contract.fromMap(reminderSnapshot.value));
        }
        store.dispatch(SetContractsAction(store.state.contractsPageState, contractsToUpdate, await ContractTemplateDao.getAll()));
      });
  }
}