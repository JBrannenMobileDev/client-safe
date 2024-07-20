import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../firebase/collections/SessionTypesCollection.dart';

class SessionTypeDao extends Equatable{
  static const String SESSION_TYPE_STORE_NAME = 'sessionType';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _sessionTypeStore = sembast.intMapStoreFactory.store(SESSION_TYPE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(SessionType sessionType) async {
    sessionType.documentId = Uuid().v1();
    sessionType.id = await _sessionTypeStore.add(await _db, sessionType.toMap());
    await SessionTypesCollection().createSessionType(sessionType);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(SessionType sessionType) async {
    await _sessionTypeStore.add(await _db, sessionType.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.sessionTypesLastChangedTime = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(SessionType newSessionType) async {
    List<SessionType>? sessionTypeList = await getAll();
    bool alreadyExists = false;
    for(SessionType sessionType in sessionTypeList!){
      if(newSessionType.documentId == sessionType.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(newSessionType);
    }else{
      await insert(newSessionType);
    }
  }

  static Future update(SessionType sessionType) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', sessionType.documentId));
    await _sessionTypeStore.update(
      await _db,
      sessionType.toMap(),
      finder: finder,
    );
    await SessionTypesCollection().updateSessionType(sessionType);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(SessionType sessionType) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', sessionType.documentId));
    await _sessionTypeStore.update(
      await _db,
      sessionType.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _sessionTypeStore.delete(
      await _db,
      finder: finder,
    );
    await SessionTypesCollection().deleteSessionType(documentId);
    _updateLastChangedTime();
  }

  static Future<List<SessionType>?> getAll() async {
    final recordSnapshots = await _sessionTypeStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final sessionType = SessionType.fromMap(snapshot.value);
      sessionType.id = snapshot.key;
      return sessionType;
    }).toList();
  }

  static Future<SessionType?> getSessionTypeById(String documentId) async{
    if((await getAll())!.isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _sessionTypeStore.find(await _db, finder: finder);
      List<SessionType> list = recordSnapshots.map((snapshot) {
        final sessionType = SessionType.fromMap(snapshot.value);
        sessionType.id = snapshot.key;
        return sessionType;
      }).toList();
      if(list.isNotEmpty) {
        return list.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getSessionTypeStream() async {
    var query = _sessionTypeStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getSessionTypeStreamFromFireStore() {
    return SessionTypesCollection().getSessionTypesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<SessionType>? allLocalSessionTypes = await getAll();
    List<SessionType>? allFireStoreSessionTypes = await SessionTypesCollection().getAll(UidUtil().getUid());

    if(allLocalSessionTypes != null && allLocalSessionTypes.isNotEmpty) {
      if(allFireStoreSessionTypes != null && allFireStoreSessionTypes.isNotEmpty) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalSessionTypes, allFireStoreSessionTypes);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalSessionTypes(allLocalSessionTypes);
      }
    } else {
      if(allFireStoreSessionTypes != null && allFireStoreSessionTypes.isNotEmpty){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreSessionTypesToLocal(allFireStoreSessionTypes);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalSessionTypes(List<SessionType> allLocalSessionTypes) async {
    for(SessionType sessionType in allLocalSessionTypes) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', sessionType.documentId));
      await _sessionTypeStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreSessionTypesToLocal(List<SessionType> allFireStoreSessionTypes) async {
    for (SessionType sessionTypesToSave in allFireStoreSessionTypes) {
      await _sessionTypeStore.add(await _db, sessionTypesToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<SessionType> allLocalSessionTypes, List<SessionType> allFireStoreSessionTypes) async {
    for(SessionType localReminder in allLocalSessionTypes) {
      //should only be 1 matching
      List<SessionType> matchingFireStoreSessionTypes = allFireStoreSessionTypes.where((fireStoreReminder) => localReminder.documentId == fireStoreReminder.documentId).toList();
      if(matchingFireStoreSessionTypes.isNotEmpty) {
        SessionType fireStoreSessionType = matchingFireStoreSessionTypes.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreSessionType.documentId));
        await _sessionTypeStore.update(
          await _db,
          fireStoreSessionType.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localReminder.documentId));
        await _sessionTypeStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(SessionType fireStoreSessionTypes in allFireStoreSessionTypes) {
      List<SessionType> matchingLocalSessionTypes = allLocalSessionTypes.where((localReminders) => localReminders.documentId == fireStoreSessionTypes.documentId).toList();
      if(matchingLocalSessionTypes.isNotEmpty) {
        //do nothing. SingleExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreSessionTypes.id = null;
        await _sessionTypeStore.add(await _db, fireStoreSessionTypes.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<SessionType>? reminders = await getAll();
    _deleteAllLocalSessionTypes(reminders!);
  }

  static getByName(String title) async {
    List<SessionType>? all = await getAll();
    for(SessionType type in all!) {
      if(type.title == title) return type;
    }
    return null;
  }
}