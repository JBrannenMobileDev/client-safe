import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/PendingEmail.dart';
import '../../firebase/collections/PendingEmailCollection.dart';

class PendingEmailDao extends Equatable{
  static const String PENDING_EMAILS_STORE_NAME = 'pendingEmails';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _pendingEmailsStore = sembast.intMapStoreFactory.store(PENDING_EMAILS_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<PendingEmail> insert(PendingEmail pendingEmail) async {
    pendingEmail.documentId = Uuid().v1();
    pendingEmail.id = await _pendingEmailsStore.add(await _db, pendingEmail.toMap());
    await PendingEmailCollection().createPendingEmail(pendingEmail);
    return pendingEmail;
  }

  static Future insertLocalOnly(PendingEmail pendingEmail) async {
    pendingEmail.id = null;
    await _pendingEmailsStore.add(await _db, pendingEmail.toMap());
  }

  static Future<PendingEmail> insertOrUpdate(PendingEmail pendingEmail) async {
    List<PendingEmail>? pendingEmailList = await getAll();
    bool alreadyExists = false;
    for(PendingEmail singlePendingEmail in pendingEmailList!){
      if(singlePendingEmail.documentId == pendingEmail.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(pendingEmail);
    }else{
      return await insert(pendingEmail);
    }
  }

  static Future<PendingEmail?> getPreviousStageEmailByUid(String uid) async {
    List<PendingEmail>? all = await getAll();
    if(all != null) {
      for(PendingEmail email in all) {
        if(email.uid == uid && isTypePreviousStage(email.emailType)) {
          return email;
        }
      }
    }
    return null;
  }

  static bool isTypePreviousStage(String type) {
    if(
      type == PendingEmail.TYPE_VIEW_CLIENT_PORTAL ||
      type == PendingEmail.TYPE_VIEW_EXAMPLE_JOB ||
      type == PendingEmail.TYPE_SETUP_YOU_BRAND ||
      type == PendingEmail.TYPE_CREATE_PRICE_PACKAGE ||
      type == PendingEmail.TYPE_ADD_FIRST_CLIENT ||
      type == PendingEmail.TYPE_CREATE_FIRST_JOB ||
      type == PendingEmail.TYPE_CREATE_CONTRACT ||
      type == PendingEmail.TYPE_ADD_CONTRACT_TO_JOB ||
      type == PendingEmail.TYPE_ADD_INVOICE_TO_JOB ||
      type == PendingEmail.TYPE_ADD_QUESTIONNAIRE_TO_JOB ||
      type == PendingEmail.TYPE_ADD_POSES_TO_JOB ||
      type == PendingEmail.TYPE_ADD_LOCATION_TO_JOB
    ) {
      return true;
    }
    return false;
  }

  static Future<PendingEmail?> getById(String pendingEmailDocumentId) async{
    if((await getAll())!.isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', pendingEmailDocumentId));
      final recordSnapshots = await _pendingEmailsStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<PendingEmail> pendingEmails = recordSnapshots.map((snapshot) {
        final pendingEmail = PendingEmail.fromMap(snapshot.value);
        pendingEmail.id = snapshot.key;
        return pendingEmail;
      }).toList();
      if(pendingEmails.isNotEmpty) {
        return pendingEmails.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<PendingEmail> update(PendingEmail pendingEmail) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', pendingEmail.documentId));
    await _pendingEmailsStore.update(
      await _db,
      pendingEmail.toMap(),
      finder: finder,
    );
    await PendingEmailCollection().updatePendingEmail(pendingEmail);
    return pendingEmail;
  }

  static Future updateLocalOnly(PendingEmail pendingEmail) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', pendingEmail.documentId));
    await _pendingEmailsStore.update(
      await _db,
      pendingEmail.toMap(),
      finder: finder,
    );
  }

  static Future delete(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _pendingEmailsStore.delete(
      await _db,
      finder: finder,
    );
    await PendingEmailCollection().delete(documentId);
  }

  static Future<List<PendingEmail>?> getAll() async {
    final recordSnapshots = await _pendingEmailsStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final pendingEmail = PendingEmail.fromMap(snapshot.value);
      pendingEmail.id = snapshot.key;
      return pendingEmail;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<PendingEmail>? allLocalPendingEmails = await getAll();
    List<PendingEmail>? allFireStorePendingEmails = await PendingEmailCollection().getAll(UidUtil().getUid());

    if(allLocalPendingEmails != null && allLocalPendingEmails.isNotEmpty) {
      if(allFireStorePendingEmails != null && allFireStorePendingEmails.isNotEmpty) {
        //both local and fireStore have PendingEmails
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalPendingEmails, allFireStorePendingEmails);
      } else {
        //all PendingEmails have been deleted in the cloud. Delete all local PendingEmails also.
        _deleteAllLocalPendingEmails(allLocalPendingEmails);
      }
    } else {
      if(allFireStorePendingEmails != null && allFireStorePendingEmails.isNotEmpty){
        //no local PendingEmails but there are fireStore PendingEmails.
        await _copyAllFireStorePendingEmailsToLocal(allFireStorePendingEmails);
      } else {
        //no PendingEmails in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalPendingEmails(List<PendingEmail> allLocalPendingEmails) async {
    for(PendingEmail pendingEmail in allLocalPendingEmails) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', pendingEmail.documentId));
      await _pendingEmailsStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStorePendingEmailsToLocal(List<PendingEmail> allFireStorePendingEmails) async {
    for (PendingEmail PendingEmailToSave in allFireStorePendingEmails) {
      await _pendingEmailsStore.add(await _db, PendingEmailToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<PendingEmail> allLocalPendingEmails, List<PendingEmail> allFireStorePendingEmails) async {
    for(PendingEmail localPendingEmail in allLocalPendingEmails) {
      //should only be 1 matching
      List<PendingEmail> matchingFireStorePendingEmails = allFireStorePendingEmails.where((fireStorePendingEmail) => localPendingEmail.documentId == fireStorePendingEmail.documentId).toList();
      if(matchingFireStorePendingEmails.isNotEmpty) {
        PendingEmail fireStorePendingEmail = matchingFireStorePendingEmails.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStorePendingEmail.documentId));
        await _pendingEmailsStore.update(
          await _db,
          fireStorePendingEmail.toMap(),
          finder: finder,
        );
      } else {
        //PendingEmail does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localPendingEmail.documentId));
        await _pendingEmailsStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(PendingEmail fireStorePendingEmail in allFireStorePendingEmails) {
      List<PendingEmail> matchingLocalPendingEmails = allLocalPendingEmails.where((localPendingEmail) => localPendingEmail.documentId == fireStorePendingEmail.documentId).toList();
      if(matchingLocalPendingEmails.isNotEmpty) {
        //do nothing. PendingEmail already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStorePendingEmail.id = null;
        await _pendingEmailsStore.add(await _db, fireStorePendingEmail.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<PendingEmail>? pendingEmails = await getAll();
    _deleteAllLocalPendingEmails(pendingEmails!);
  }

  static void deleteAllRemote() async {
    List<PendingEmail>? pendingEmails = await getAll();
    for(PendingEmail pendingEmail in pendingEmails!) {
      await delete(pendingEmail.documentId);
    }
  }
}