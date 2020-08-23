import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/JobReminderCollection.dart';
import 'package:dandylight/data_layer/firebase/collections/ReminderCollection.dart';
import 'package:dandylight/data_layer/firebase/collections/SingleExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class JobReminderDao extends Equatable{
  static const String JOB_REMINDER_STORE_NAME = 'jobReminder';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _jobReminderStore = intMapStoreFactory.store(JOB_REMINDER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(JobReminder reminder) async {
    reminder.documentId = Uuid().v1();
    reminder.id = await _jobReminderStore.add(await _db, reminder.toMap());
    await JobReminderCollection().createReminder(reminder);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(JobReminder reminder) async {
    await _jobReminderStore.add(await _db, reminder.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.jobReminderLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(JobReminder newReminder) async {
    List<JobReminder> reminderList = await getAll();
    bool alreadyExists = false;
    for(JobReminder reminder in reminderList){
      if(newReminder.documentId == reminder.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(newReminder);
    }else{
      await insert(newReminder);
    }
  }

  static Future update(JobReminder reminder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
    await _jobReminderStore.update(
      await _db,
      reminder.toMap(),
      finder: finder,
    );
    await JobReminderCollection().updateReminder(reminder);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(JobReminder reminder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
    await _jobReminderStore.update(
      await _db,
      reminder.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _jobReminderStore.delete(
      await _db,
      finder: finder,
    );
    await JobReminderCollection().deleteReminder(documentId);
    _updateLastChangedTime();
  }

  static Future<List<JobReminder>> getAll() async {
    final recordSnapshots = await _jobReminderStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final reminder = JobReminder.fromMap(snapshot.value);
      reminder.id = snapshot.key;
      return reminder;
    }).toList();
  }

  static Future<JobReminder> getReminderById(String documentId) async{
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    final recordSnapshots = await _jobReminderStore.find(await _db, finder: finder);
    return recordSnapshots.map((snapshot) {
      final reminder = JobReminder.fromMap(snapshot.value);
      reminder.id = snapshot.key;
      return reminder;
    }).toList().elementAt(0);
  }

  static Future<Stream<List<RecordSnapshot>>> getReminderStream() async {
    var query = _jobReminderStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getReminderStreamFromFireStore() {
    return JobReminderCollection().getReminderStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<JobReminder> allLocalReminders = await getAll();
    List<JobReminder> allFireStoreReminder = await JobReminderCollection().getAll(UidUtil().getUid());

    if(allLocalReminders != null && allLocalReminders.length > 0) {
      if(allFireStoreReminder != null && allFireStoreReminder.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalReminders, allFireStoreReminder);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalReminders(allLocalReminders);
      }
    } else {
      if(allFireStoreReminder != null && allFireStoreReminder.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreRemindersToLocal(allFireStoreReminder);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalReminders(List<JobReminder> allLocalReminders) async {
    for(JobReminder reminder in allLocalReminders) {
      final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
      await _jobReminderStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreRemindersToLocal(List<JobReminder> allFireStoreReminders) async {
    for (JobReminder reminderToSave in allFireStoreReminders) {
      await _jobReminderStore.add(await _db, reminderToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<JobReminder> allLocalReminders, List<JobReminder> allFireStoreReminders) async {
    for(JobReminder localReminder in allLocalReminders) {
      //should only be 1 matching
      List<JobReminder> matchingFireStoreReminders = allFireStoreReminders.where((fireStoreReminder) => localReminder.documentId == fireStoreReminder.documentId).toList();
      if(matchingFireStoreReminders !=  null && matchingFireStoreReminders.length > 0) {
        JobReminder fireStoreReminder = matchingFireStoreReminders.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreReminder.documentId));
        await _jobReminderStore.update(
          await _db,
          fireStoreReminder.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localReminder.documentId));
        await _jobReminderStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(JobReminder fireStoreReminder in allFireStoreReminders) {
      List<JobReminder> matchingLocalReminders = allLocalReminders.where((localReminders) => localReminders.documentId == fireStoreReminder.documentId).toList();
      if(matchingLocalReminders != null && matchingLocalReminders.length > 0) {
        //do nothing. SingleExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreReminder.id = null;
        await _jobReminderStore.add(await _db, fireStoreReminder.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}