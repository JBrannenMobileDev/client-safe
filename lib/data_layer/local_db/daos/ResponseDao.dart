import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/ResponseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/Response.dart';

class ResponseDao extends Equatable{
  static const String RESPONSE_STORE_NAME = 'response';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _responseStore = sembast.intMapStoreFactory.store(RESPONSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(Response response) async {
    response.documentId = Uuid().v1();
    response.id = await _responseStore.add(await _db, response.toMap());
    await ResponseCollection().createResponse(response);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(Response response) async {
    await _responseStore.add(await _db, response.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.responsesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(Response response) async {
    List<Response> responseList = await getAll();
    bool alreadyExists = false;
    for(Response expense in responseList){
      if(expense.documentId == response.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(response);
    }else{
      await insert(response);
    }
  }

  static Future update(Response response) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', response.documentId));
    await _responseStore.update(
      await _db,
      response.toMap(),
      finder: finder,
    );
    await ResponseCollection().updateResponse(response);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(Response response) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', response.documentId));
    await _responseStore.update(
      await _db,
      response.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _responseStore.delete(
      await _db,
      finder: finder,
    );
    await ResponseCollection().deleteResponse(documentId);
    _updateLastChangedTime();
  }

  static Future<List<Response>> getAll() async {
    final recordSnapshots = await _responseStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final response = Response.fromMap(snapshot.value);
      response.id = snapshot.key;
      return response;
    }).toList();
  }

  static Future<Response?> getResponseById(String documentId) async{
    if((await getAll()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _responseStore.find(await _db, finder: finder);
      List<Response> responses = recordSnapshots.map((snapshot) {
        final expense = Response.fromMap(snapshot.value);
        expense.id = snapshot.key;
        return expense;
      }).toList();
      if(responses.length > 0) return responses.elementAt(0);
      return null;
    } else {
      return null;
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getResponseStream() async {
    var query = _responseStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getResponsesStreamFromFireStore() {
    return ResponseCollection().getResponseStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Response> allLocalResponses = await getAll();
    List<Response> allFireStoreResponses = await ResponseCollection().getAll(UidUtil().getUid());

    if(allLocalResponses != null && allLocalResponses.length > 0) {
      if(allFireStoreResponses != null && allFireStoreResponses.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalResponses, allFireStoreResponses);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalResponses(allLocalResponses);
      }
    } else {
      if(allFireStoreResponses != null && allFireStoreResponses.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreResponsesToLocal(allFireStoreResponses);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalResponses(List<Response> allLocalResponses) async {
    for(Response expense in allLocalResponses) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', expense.documentId));
      await _responseStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreResponsesToLocal(List<Response> allFireStoreResponses) async {
    for (Response singleToSave in allFireStoreResponses) {
      await _responseStore.add(await _db, singleToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Response> allLocalResponses, List<Response> allFireStoreResponses) async {
    for(Response localResponse in allLocalResponses) {
      //should only be 1 matching
      List<Response> matchingFireStoreResponses = allFireStoreResponses.where((fireStoreResponse) => localResponse.documentId == fireStoreResponse.documentId).toList();
      if(matchingFireStoreResponses !=  null && matchingFireStoreResponses.length > 0) {
        Response fireStoreResponse = matchingFireStoreResponses.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreResponse.documentId));
        await _responseStore.update(
          await _db,
          fireStoreResponse.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localResponse.documentId));
        await _responseStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Response fireStoreResponse in allFireStoreResponses) {
      List<Response> matchingLocalResponses = allLocalResponses.where((localResponse) => localResponse.documentId == fireStoreResponse.documentId).toList();
      if(matchingLocalResponses != null && matchingLocalResponses.length > 0) {
        //do nothing. Response already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreResponse.id = null;
        await _responseStore.add(await _db, fireStoreResponse.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Response> expenses = await getAll();
    _deleteAllLocalResponses(expenses);
  }
}