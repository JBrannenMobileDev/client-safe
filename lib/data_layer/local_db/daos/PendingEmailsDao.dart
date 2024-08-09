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

  static Future delete(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _pendingEmailsStore.delete(
      await _db,
      finder: finder,
    );
    await PendingEmailCollection().delete(documentId);
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}