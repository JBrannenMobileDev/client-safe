
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/pages/contracts_page/ContractsActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';


import '../../data_layer/repositories/FileStorage.dart';
import '../../models/Contract.dart';
import 'NewContractActions.dart';

class NewContractPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveContractAction){
      _saveContract(store, action, next);
    }
    if(action is DeleteContract){
      _deleteContract(store, action, next);
    }
  }

  void _saveContract(Store<AppState> store, SaveContractAction action, NextDispatcher next) async{
    Contract contract = Contract();
    contract.id = action.pageState.id;
    contract.documentId = action.pageState.documentId;
    contract.contractName = action.pageState.contractName;

    Contract contractWithId = await ContractDao.insertOrUpdate(contract);


    await FileStorage.saveContractFile(action.pageState.documentFilePath, contractWithId);
    store.dispatch(ClearStateAction(store.state.newContractPageState));
    store.dispatch(FetchContractsAction(store.state.contractsPageState));
  }

  void _deleteContract(Store<AppState> store, DeleteContract action, NextDispatcher next) async{
    await ContractDao.delete(action.pageState.documentId);
    Contract contract = await ContractDao.getById(action.pageState.documentId);
    if(contract != null) {
      await ContractDao.delete(action.pageState.documentId);
    }
    store.dispatch(FetchContractsAction(store.state.contractsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}