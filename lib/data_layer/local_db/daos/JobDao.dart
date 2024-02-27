import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/JobCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/JobStage.dart';
import '../../../utils/NotificationHelper.dart';
import '../../../utils/analytics/EventSender.dart';

class JobDao extends Equatable{
  static const String JOB_STORE_NAME = 'jobs';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _jobStore = sembast.intMapStoreFactory.store(JOB_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(Job job) async {
    job.documentId = Uuid().v1();
    int jobId = await _jobStore.add(await _db, job.toMap());
    job.id = jobId;
    await JobCollection().createJob(job);
    _updateLastChangedTime();
    _updateProfileJobCount();
    CalendarSyncUtil.insertJobEvent(job);
  }

  static Future<void> _updateProfileJobCount() async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.jobsCreatedCount = profile.jobsCreatedCount + 1;
    ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.JOB_COUNT, profile.jobsCreatedCount);
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
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
      try{
        NotificationHelper().turnOffNotificationById(NotificationHelper.START_FIRST_JOB_ID);
      } catch(ex) {
        print(ex);
      }
    }
  }

  static Future update(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    Job previousJobState = await getJobById(job.documentId);
    if(Job.containsStage(job.completedStages, JobStage.STAGE_14_JOB_COMPLETE) && !Job.containsStage(previousJobState.completedStages, JobStage.STAGE_14_JOB_COMPLETE)) {
      if(job.paymentReceivedDate == null) {
        job.paymentReceivedDate = DateTime.now();
      }
      if(job.invoice != null) {
        job.invoice.invoicePaid = true;
        await InvoiceDao.updateInvoiceOnly(job.invoice);
      }
    }

    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', job.documentId));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
    try{
      await JobCollection().updateJob(job);
    } catch (e) {
      print(e);
    }
    await _updateLastChangedTime();
    CalendarSyncUtil.updateJobEvent(job);
  }

  static Future updateLocalOnly(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', job.documentId));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
  }

  static Future delete(Job job) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', job.documentId));
    await _jobStore.delete(
      await _db,
      finder: finder,
    );
    await JobCollection().deleteJob(job.documentId);
    _updateLastChangedTime();
    CalendarSyncUtil.deleteJobEvent(job);
    JobReminderDao.deleteAllWithJobDocumentId(job.documentId);
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
    if((await getAllJobs()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', jobDocumentId));
      final recordSnapshots = await _jobStore.find(await _db, finder: finder);
      List<Job> jobs = recordSnapshots.map((snapshot) {
        final job = Job.fromMap(snapshot.value);
        job.id = snapshot.key;
        return job;
      }).toList();
      if(jobs.isNotEmpty) {
        return jobs.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getJobsStream() async {
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
        _deleteAllLocalJobs(allLocalJobs);
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

  static Future<void> _deleteAllLocalJobs(List<Job> allLocalJobs) async {
    for(Job job in allLocalJobs) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', job.documentId));
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
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreJob.documentId));
        await _jobStore.update(
          await _db,
          fireStoreJob.toMap(),
          finder: finder,
        );
      } else {
        //Job does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localJob.documentId));
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

  static void deleteAllLocal() async {
    List<Job> jobs = await getAllJobs();
    _deleteAllLocalJobs(jobs);
  }

  static getJobBycreatedDate(DateTime createdDate) async {
    List<Job> allJobs = await getAllJobs();
    for(Job job in allJobs){
      if(job.createdDate.millisecondsSinceEpoch == createdDate.millisecondsSinceEpoch) return job;
    }
    return null;
  }
}