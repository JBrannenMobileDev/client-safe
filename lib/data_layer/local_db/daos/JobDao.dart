import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/JobCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class JobDao extends Equatable{
  static const String JOB_STORE_NAME = 'jobs';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _jobStore = intMapStoreFactory.store(JOB_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Job job) async {
    job.documentId = Uuid().v1();
    int jobId = await _jobStore.add(await _db, job.toMap());
    job.id = jobId;
    await JobCollection().createJob(job);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.jobsLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocalOnly(Job job) async {
    job.id = null;
    await _jobStore.add(await _db, job.toMap());
  }

  static Future insertOrUpdate(Job job) async {
    List<Job> jobList = await getAllJobs();
    bool alreadyExists = false;
    for(Job singleJob in jobList){
      if(singleJob.documentId == job.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(job);
    }else{
      await insert(job);
    }
  }

  static Future update(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', job.documentId));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
    await JobCollection().updateJob(job);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', job.documentId));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
  }

  static Future delete(Job job) async {
    final finder = Finder(filter: Filter.equals('documentId', job.documentId));
    await _jobStore.delete(
      await _db,
      finder: finder,
    );
    await JobCollection().deleteJob(job.documentId);
    _updateLastChangedTime();
  }

   static Future<List<Job>> getAllJobs() async {
    final recordSnapshots = await _jobStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static Future<Job> getJobById(String jobDocumentId) async{
    final finder = Finder(filter: Filter.equals('documentId', jobDocumentId));
    final recordSnapshots = await _jobStore.find(await _db, finder: finder);
    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList().elementAt(0);
  }

  static Future<Stream<List<RecordSnapshot>>> getJobsStream() async {
    var query = _jobStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getJobsStreamFromFireStore() {
    return JobCollection().getJobsStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Job> allLocalJobs = await getAllJobs();
    List<Job> allFireStoreJobs = await JobCollection().getAll(UidUtil().getUid());

    if(allLocalJobs != null && allLocalJobs.length > 0) {
      if(allFireStoreJobs != null && allFireStoreJobs.length > 0) {
        //both local and fireStore have Jobs
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalJobs, allFireStoreJobs);
      } else {
        //all Jobs have been deleted in the cloud. Delete all local Jobs also.
        deleteAllLocalJobs(allLocalJobs);
      }
    } else {
      if(allFireStoreJobs != null && allFireStoreJobs.length > 0){
        //no local Jobs but there are fireStore Jobs.
        await _copyAllFireStoreJobsToLocal(allFireStoreJobs);
      } else {
        //no Jobs in either database. nothing to sync.
      }
    }
  }

  static Future<void> deleteAllLocalJobs(List<Job> allLocalJobs) async {
    for(Job job in allLocalJobs) {
      final finder = Finder(filter: Filter.equals('documentId', job.documentId));
      await _jobStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreJobsToLocal(List<Job> allFireStoreJobs) async {
    for (Job JobToSave in allFireStoreJobs) {
      await _jobStore.add(await _db, JobToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Job> allLocalJobs, List<Job> allFireStoreJobs) async {
    for(Job localJob in allLocalJobs) {
      //should only be 1 matching
      List<Job> matchingFireStoreJobs = allFireStoreJobs.where((fireStoreJob) => localJob.documentId == fireStoreJob.documentId).toList();
      if(matchingFireStoreJobs !=  null && matchingFireStoreJobs.length > 0) {
        Job fireStoreJob = matchingFireStoreJobs.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreJob.documentId));
        await _jobStore.update(
          await _db,
          fireStoreJob.toMap(),
          finder: finder,
        );
      } else {
        //Job does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localJob.documentId));
        await _jobStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Job fireStoreJob in allFireStoreJobs) {
      List<Job> matchingLocalJobs = allLocalJobs.where((localJob) => localJob.documentId == fireStoreJob.documentId).toList();
      if(matchingLocalJobs != null && matchingLocalJobs.length > 0) {
        //do nothing. Job already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreJob.id = null;
        await _jobStore.add(await _db, fireStoreJob.toMap());
      }
    }
  }
}