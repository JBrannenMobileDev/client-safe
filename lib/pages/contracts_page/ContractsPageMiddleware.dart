import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import 'ContractsActions.dart';

class ContractsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchContractsAction){
      fetchContracts(store, next);
    }
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