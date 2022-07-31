import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/ReminderCollection.dart';
import 'package:dandylight/data_layer/firebase/collections/SingleExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class ReminderDao extends Equatable{
  static const String REMINDER_STORE_NAME = 'reminder';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _reminderStore = intMapStoreFactory.store(REMINDER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(ReminderDandyLight reminder) async {
    reminder.documentId = Uuid().v1();
    reminder.id = await _reminderStore.add(await _db, reminder.toMap());
    await ReminderCollection().createReminder(reminder);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(ReminderDandyLight reminder) async {
    await _reminderStore.add(await _db, reminder.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.remindersLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(ReminderDandyLight newReminder) async {
    List<ReminderDandyLight> reminderList = await getAll();
    bool alreadyExists = false;
    for(ReminderDandyLight reminder in reminderList){
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

  static Future update(ReminderDandyLight reminder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
    await _reminderStore.update(
      await _db,
      reminder.toMap(),
      finder: finder,
    );
    await ReminderCollection().updateReminder(reminder);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(ReminderDandyLight reminder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
    await _reminderStore.update(
      await _db,
      reminder.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _reminderStore.delete(
      await _db,
      finder: finder,
    );
    await ReminderCollection().deleteReminder(documentId);
    _updateLastChangedTime();
  }

  static Future<List<ReminderDandyLight>> getAll() async {
    final recordSnapshots = await _reminderStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final reminder = ReminderDandyLight.fromMap(snapshot.value);
      reminder.id = snapshot.key;
      return reminder;
    }).toList();
  }

  static Future<ReminderDandyLight> getReminderById(String documentId) async{
    if((await getAll()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', documentId));
      final recordSnapshots = await _reminderStore.find(await _db, finder: finder);
      return recordSnapshots.map((snapshot) {
        final reminder = ReminderDandyLight.fromMap(snapshot.value);
        reminder.id = snapshot.key;
        return reminder;
      }).toList().elementAt(0);
    } else {
      return null;
    }
  }

  static Future<Stream<List<RecordSnapshot>>> getReminderStream() async {
    var query = _reminderStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getReminderStreamFromFireStore() {
    return ReminderCollection().getReminderStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<ReminderDandyLight> allLocalReminders = await getAll();
    List<ReminderDandyLight> allFireStoreReminder = await ReminderCollection().getAll(UidUtil().getUid());

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

  static Future<void> _deleteAllLocalReminders(List<ReminderDandyLight> allLocalReminders) async {
    for(ReminderDandyLight reminder in allLocalReminders) {
      final finder = Finder(filter: Filter.equals('documentId', reminder.documentId));
      await _reminderStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreRemindersToLocal(List<ReminderDandyLight> allFireStoreReminders) async {
    for (ReminderDandyLight reminderToSave in allFireStoreReminders) {
      await _reminderStore.add(await _db, reminderToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<ReminderDandyLight> allLocalReminders, List<ReminderDandyLight> allFireStoreReminders) async {
    for(ReminderDandyLight localReminder in allLocalReminders) {
      //should only be 1 matching
      List<ReminderDandyLight> matchingFireStoreReminders = allFireStoreReminders.where((fireStoreReminder) => localReminder.documentId == fireStoreReminder.documentId).toList();
      if(matchingFireStoreReminders !=  null && matchingFireStoreReminders.length > 0) {
        ReminderDandyLight fireStoreReminder = matchingFireStoreReminders.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreReminder.documentId));
        await _reminderStore.update(
          await _db,
          fireStoreReminder.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localReminder.documentId));
        await _reminderStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(ReminderDandyLight fireStoreReminder in allFireStoreReminders) {
      List<ReminderDandyLight> matchingLocalReminders = allLocalReminders.where((localReminders) => localReminders.documentId == fireStoreReminder.documentId).toList();
      if(matchingLocalReminders != null && matchingLocalReminders.length > 0) {
        //do nothing. SingleExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreReminder.id = null;
        await _reminderStore.add(await _db, fireStoreReminder.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<ReminderDandyLight> reminders = await getAll();
    _deleteAllLocalReminders(reminders);
  }
}