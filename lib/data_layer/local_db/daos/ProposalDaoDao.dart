import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/MileageExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import '../../../models/Proposal.dart';

class ProposalDao extends Equatable{
  static const String PROPOSAL_STORE_NAME = 'mileageExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _proposalStore = intMapStoreFactory.store(PROPOSAL_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(MileageExpense mileageExpense) async {
    mileageExpense.documentId = Uuid().v1();
    mileageExpense.id = await _proposalStore.add(await _db, mileageExpense.toMap());
  }

  static Future insertLocalOnly(MileageExpense mileageExpense) async {
    await _proposalStore.add(await _db, mileageExpense.toMap());
  }

  static Future insertOrUpdate(Proposal newProposal) async {
    List<Proposal> proposalList = await getAll();
    bool alreadyExists = false;
    for(Proposal proposal in proposalList){
      if(proposal.id == newProposal.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(mileageExpense);
    }else{
      await insert(mileageExpense);
    }
  }

  static Future update(Proposal proposal) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('id', proposal.id));
    await _proposalStore.update(
      await _db,
      proposal.toMap(),
      finder: finder,
    ).catchError((error) {
      print(error);
    });
  }

  static Future updateLocalOnly(Proposal proposal) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('id', proposal.id));
    await _proposalStore.update(
      await _db,
      proposal.toMap(),
      finder: finder,
    );
  }

  static Future delete(String id) async {
    final finder = Finder(filter: Filter.equals('id', id));
    await _proposalStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<MileageExpense>> getAll() async {
    final recordSnapshots = await _proposalStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final mileageExpense = MileageExpense.fromMap(snapshot.value);
      mileageExpense.id = snapshot.key;
      return mileageExpense;
    }).toList();
  }

  static Future<MileageExpense> getMileageExpenseById(String documentId) async{
    if((await getAll()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', documentId));
      final recordSnapshots = await _proposalStore.find(await _db, finder: finder);
      return recordSnapshots.map((snapshot) {
        final expense = MileageExpense.fromMap(snapshot.value);
        expense.id = snapshot.key;
        return expense;
      }).toList().elementAt(0);
    } else {
      return null;
    }
  }

  static Future<Stream<List<RecordSnapshot>>> getMileageExpenseStream() async {
    var query = _proposalStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getMileageExpensesStreamFromFireStore() {
    return MileageExpenseCollection().getExpensesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<MileageExpense> allLocalMileageExpenses = await getAll();
    List<MileageExpense> allFireStoreMileageExpenses = await MileageExpenseCollection().getAll(UidUtil().getUid());

    if(allLocalMileageExpenses != null && allLocalMileageExpenses.length > 0) {
      if(allFireStoreMileageExpenses != null && allFireStoreMileageExpenses.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalMileageExpenses, allFireStoreMileageExpenses);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalMileageExpenses(allLocalMileageExpenses);
      }
    } else {
      if(allFireStoreMileageExpenses != null && allFireStoreMileageExpenses.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreMileageExpensesToLocal(allFireStoreMileageExpenses);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalMileageExpenses(List<MileageExpense> allLocalMileageExpenses) async {
    for(MileageExpense expense in allLocalMileageExpenses) {
      final finder = Finder(filter: Filter.equals('documentId', expense.documentId));
      await _proposalStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreMileageExpensesToLocal(List<MileageExpense> allFireStoreMileageExpenses) async {
    for (MileageExpense clientToSave in allFireStoreMileageExpenses) {
      await _proposalStore.add(await _db, clientToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<MileageExpense> allLocalMileageExpenses, List<MileageExpense> allFireStoreMileageExpenses) async {
    for(MileageExpense localMileageExpense in allLocalMileageExpenses) {
      //should only be 1 matching
      List<MileageExpense> matchingFireStoreMileageExpenses = allFireStoreMileageExpenses.where((fireStoreMileageExpense) => localMileageExpense.documentId == fireStoreMileageExpense.documentId).toList();
      if(matchingFireStoreMileageExpenses !=  null && matchingFireStoreMileageExpenses.length > 0) {
        MileageExpense fireStoreMileageExpense = matchingFireStoreMileageExpenses.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreMileageExpense.documentId));
        await _proposalStore.update(
          await _db,
          fireStoreMileageExpense.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localMileageExpense.documentId));
        await _proposalStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(MileageExpense fireStoreMileageExpense in allFireStoreMileageExpenses) {
      List<MileageExpense> matchingLocalMileageExpenses = allLocalMileageExpenses.where((localMileageExpense) => localMileageExpense.documentId == fireStoreMileageExpense.documentId).toList();
      if(matchingLocalMileageExpenses != null && matchingLocalMileageExpenses.length > 0) {
        //do nothing. MileageExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreMileageExpense.id = null;
        await _proposalStore.add(await _db, fireStoreMileageExpense.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<MileageExpense> expenses = await getAll();
    _deleteAllLocalMileageExpenses(expenses);
  }
}