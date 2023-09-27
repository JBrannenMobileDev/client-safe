import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ContractTemplateDao.dart';
import '../../models/Contract.dart';
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
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    next(SetProfileForContractEditAction(store.state.contractEditPageState, profile));
  }

  void deleteContract(Store<AppState> store, DeleteContractAction action, NextDispatcher next) async{
    if(action.pageState.contract != null) {
      await ContractDao.delete(action.pageState.contract.documentId);
      await ContractDao.delete(action.pageState.contract.documentId);
    }
  }

  void saveContract(Store<AppState> store, SaveContractAction action, NextDispatcher next) async{
    Contract contract = null;
    if(action.pageState.contract == null) {
      contract = Contract(
        contractName: action.pageState.contractName,
        terms: action.quillContract.toPlainText(),
        jsonTerms: jsonEncode(action.quillContract.toDelta().toJson()),
        signedByPhotographer: true,
      );
      if(action.pageState.isNew) {
        contract.documentId = null;
      }
    } else {
      contract = action.pageState.contract;
      if(action.pageState.isNew) {
        contract.documentId = null;
      }
      contract.contractName = action.pageState.contractName;
      contract.terms = action.quillContract.toPlainText();
      contract.jsonTerms = jsonEncode(action.quillContract.toDelta().toJson());
    }
    await ContractDao.insertOrUpdate(contract);
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