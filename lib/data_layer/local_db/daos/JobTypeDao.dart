import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../firebase/collections/JobTypesCollection.dart';

class JobTypeDao extends Equatable{
  static const String JOB_TYPE_STORE_NAME = 'jobType';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _jobTypeStore = sembast.intMapStoreFactory.store(JOB_TYPE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(JobType jobType) async {
    jobType.documentId = Uuid().v1();
    jobType.id = await _jobTypeStore.add(await _db, jobType.toMap());
    await JobTypesCollection().createJobType(jobType);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(JobType jobType) async {
    await _jobTypeStore.add(await _db, jobType.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.jobTypesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(JobType newJobType) async {
    List<JobType> jobTypeList = await getAll();
    bool alreadyExists = false;
    for(JobType jobType in jobTypeList){
      if(newJobType.documentId == jobType.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(newJobType);
    }else{
      await insert(newJobType);
    }
  }

  static Future update(JobType jobType) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', jobType.documentId));
    await _jobTypeStore.update(
      await _db,
      jobType.toMap(),
      finder: finder,
    );
    await JobTypesCollection().updateJobType(jobType);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(JobType jobType) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', jobType.documentId));
    await _jobTypeStore.update(
      await _db,
      jobType.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _jobTypeStore.delete(
      await _db,
      finder: finder,
    );
    await JobTypesCollection().deleteJobType(documentId);
    _updateLastChangedTime();
  }

  static Future<List<JobType>> getAll() async {
    final recordSnapshots = await _jobTypeStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final jobType = JobType.fromMap(snapshot.value);
      jobType.id = snapshot.key;
      return jobType;
    }).toList();
  }

  static Future<JobType?> getJobTypeById(String documentId) async{
    if((await getAll()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _jobTypeStore.find(await _db, finder: finder);
      List<JobType> list = recordSnapshots.map((snapshot) {
        final jobType = JobType.fromMap(snapshot.value);
        jobType.id = snapshot.key;
        return jobType;
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

  static Future<Stream<List<sembast.RecordSnapshot>>> getJobTypeStream() async {
    var query = _jobTypeStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getJobTypeStreamFromFireStore() {
    return JobTypesCollection().getJobTypesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<JobType> allLocalJobTypes = await getAll();
    List<JobType> allFireStoreJobTypes = await JobTypesCollection().getAll(UidUtil().getUid());

    if(allLocalJobTypes != null && allLocalJobTypes.length > 0) {
      if(allFireStoreJobTypes != null && allFireStoreJobTypes.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalJobTypes, allFireStoreJobTypes);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalJobTypes(allLocalJobTypes);
      }
    } else {
      if(allFireStoreJobTypes != null && allFireStoreJobTypes.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreJobTypesToLocal(allFireStoreJobTypes);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalJobTypes(List<JobType> allLocalJobTypes) async {
    for(JobType jobType in allLocalJobTypes) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', jobType.documentId));
      await _jobTypeStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreJobTypesToLocal(List<JobType> allFireStoreJobTypes) async {
    for (JobType jobTypesToSave in allFireStoreJobTypes) {
      await _jobTypeStore.add(await _db, jobTypesToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<JobType> allLocalJobTypes, List<JobType> allFireStoreJobTypes) async {
    for(JobType localReminder in allLocalJobTypes) {
      //should only be 1 matching
      List<JobType> matchingFireStoreJobTypes = allFireStoreJobTypes.where((fireStoreReminder) => localReminder.documentId == fireStoreReminder.documentId).toList();
      if(matchingFireStoreJobTypes !=  null && matchingFireStoreJobTypes.length > 0) {
        JobType fireStoreJobType = matchingFireStoreJobTypes.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreJobType.documentId));
        await _jobTypeStore.update(
          await _db,
          fireStoreJobType.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localReminder.documentId));
        await _jobTypeStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(JobType fireStoreJobTypes in allFireStoreJobTypes) {
      List<JobType> matchingLocalJobTypes = allLocalJobTypes.where((localReminders) => localReminders.documentId == fireStoreJobTypes.documentId).toList();
      if(matchingLocalJobTypes != null && matchingLocalJobTypes.length > 0) {
        //do nothing. SingleExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreJobTypes.id = null;
        await _jobTypeStore.add(await _db, fireStoreJobTypes.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<JobType> reminders = await getAll();
    _deleteAllLocalJobTypes(reminders);
  }

  static getByName(String title) async {
    List<JobType> all = await getAll();
    for(JobType type in all) {
      if(type.title == title) return type;
    }
    return null;
  }
}