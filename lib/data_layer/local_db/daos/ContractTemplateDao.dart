import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/Contract.dart';
import '../../firebase/collections/ContractTemplateCollection.dart';

class ContractTemplateDao extends Equatable{
  static const String CONTRACT_TEMPLATE_STORE_NAME = 'contractTemplate';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _contractTemplateStore = sembast.intMapStoreFactory.store(CONTRACT_TEMPLATE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<Contract> insert(Contract contract) async {
    contract.documentId = Uuid().v1();
    contract.id = await _contractTemplateStore.add(await _db, contract.toMap());
    await ContractTemplateCollection().createContract(contract);
    return contract;
  }

  static Future insertLocalOnly(Contract contract) async {
    contract.id = null;
    await _contractTemplateStore.add(await _db, contract.toMap());
  }

  static Future<Contract> insertOrUpdate(Contract contract) async {
    List<Contract> contractList = await getAll();
    bool alreadyExists = false;
    for(Contract singleContract in contractList){
      if(singleContract.documentId == contract.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(contract);
    }else{
      return await insert(contract);
    }
  }

  static Future<Contract?> getById(String contractDocumentId) async{
    if((await getAll()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contractDocumentId));
      final recordSnapshots = await _contractTemplateStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<Contract> contracts = recordSnapshots.map((snapshot) {
        final contract = Contract.fromMap(snapshot.value);
        contract.id = snapshot.key;
        return contract;
      }).toList();
      if(contracts.isNotEmpty) {
        return contracts.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Contract> update(Contract contract) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
    await _contractTemplateStore.update(
      await _db,
      contract.toMap(),
      finder: finder,
    );
    await ContractTemplateCollection().updateContract(contract);
    return contract;
  }

  static Future updateLocalOnly(Contract contract) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
    await _contractTemplateStore.update(
      await _db,
      contract.toMap(),
      finder: finder,
    );
  }

  static Future delete(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    int countOfUpdatedItems = await _contractTemplateStore.delete(
      await _db,
      finder: finder,
    );
    await ContractTemplateCollection().deleteJob(documentId);
  }

  static Future<List<Contract>> getAll() async {
    final recordSnapshots = await _contractTemplateStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final contract = Contract.fromMap(snapshot.value);
      contract.id = snapshot.key;
      return contract;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Contract> allLocalContracts = await getAll();
    List<Contract> allFireStoreContracts = await ContractTemplateCollection().getAll(UidUtil().getUid());

    if(allLocalContracts != null && allLocalContracts.length > 0) {
      if(allFireStoreContracts != null && allFireStoreContracts.length > 0) {
        //both local and fireStore have Contracts
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalContracts, allFireStoreContracts);
      } else {
        //all Contracts have been deleted in the cloud. Delete all local Contracts also.
        _deleteAllLocalContracts(allLocalContracts);
      }
    } else {
      if(allFireStoreContracts != null && allFireStoreContracts.length > 0){
        //no local Contracts but there are fireStore Contracts.
        await _copyAllFireStoreContractsToLocal(allFireStoreContracts);
      } else {
        //no Contracts in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalContracts(List<Contract> allLocalContracts) async {
    for(Contract contract in allLocalContracts) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
      await _contractTemplateStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreContractsToLocal(List<Contract> allFireStoreContracts) async {
    for (Contract ContractToSave in allFireStoreContracts) {
      await _contractTemplateStore.add(await _db, ContractToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Contract> allLocalContracts, List<Contract> allFireStoreContracts) async {
    for(Contract localContract in allLocalContracts) {
      //should only be 1 matching
      List<Contract> matchingFireStoreContracts = allFireStoreContracts.where((fireStoreContract) => localContract.documentId == fireStoreContract.documentId).toList();
      if(matchingFireStoreContracts !=  null && matchingFireStoreContracts.length > 0) {
        Contract fireStoreContract = matchingFireStoreContracts.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreContract.documentId));
        await _contractTemplateStore.update(
          await _db,
          fireStoreContract.toMap(),
          finder: finder,
        );
      } else {
        //Contract does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localContract.documentId));
        await _contractTemplateStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Contract fireStoreContract in allFireStoreContracts) {
      List<Contract> matchingLocalContracts = allLocalContracts.where((localContract) => localContract.documentId == fireStoreContract.documentId).toList();
      if(matchingLocalContracts != null && matchingLocalContracts.length > 0) {
        //do nothing. Contract already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreContract.id = null;
        await _contractTemplateStore.add(await _db, fireStoreContract.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Contract> contracts = await getAll();
    _deleteAllLocalContracts(contracts);
  }

  static void deleteAllRemote() async {
    List<Contract> contracts = await getAll();
    for(Contract contract in contracts) {
      await delete(contract.documentId);
    }
  }
}