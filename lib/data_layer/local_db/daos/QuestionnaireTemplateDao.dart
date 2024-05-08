import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/Contract.dart';
import '../../../models/Questionnaire.dart';
import '../../firebase/collections/ContractTemplateCollection.dart';
import '../../firebase/collections/QuestionnaireTemplateCollection.dart';

class QuestionnaireTemplateDao extends Equatable{
  static const String QUESTIONNAIRE_TEMPLATE_STORE_NAME = 'questionnaireTemplate';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _questionnaireTemplateStore = sembast.intMapStoreFactory.store(QUESTIONNAIRE_TEMPLATE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<Questionnaire> insert(Questionnaire questionnaire) async {
    questionnaire.documentId = Uuid().v1();
    questionnaire.id = await _questionnaireTemplateStore.add(await _db, questionnaire.toMap());
    await QuestionnaireTemplateCollection().createQuestionnaire(questionnaire);
    return questionnaire;
  }

  static Future insertLocalOnly(Questionnaire questionnaire) async {
    questionnaire.id = null;
    await _questionnaireTemplateStore.add(await _db, questionnaire.toMap());
  }

  static Future<Questionnaire> insertOrUpdate(Questionnaire questionnaire) async {
    List<Questionnaire>? questionnaireList = await getAll();
    bool alreadyExists = false;
    for(Questionnaire singleQuestionnaire in questionnaireList!){
      if(singleQuestionnaire.documentId == questionnaire.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(questionnaire);
    }else{
      return await insert(questionnaire);
    }
  }

  static Future<Questionnaire?> getById(String questionnaireDocumentId) async{
    if((await getAll())!.isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', questionnaireDocumentId));
      final recordSnapshots = await _questionnaireTemplateStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<Questionnaire> questionnaires = recordSnapshots.map((snapshot) {
        final questionnaire = Questionnaire.fromMap(snapshot.value);
        questionnaire.id = snapshot.key;
        return questionnaire;
      }).toList();
      if(questionnaires.isNotEmpty) {
        return questionnaires.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Questionnaire> update(Questionnaire questionnaire) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', questionnaire.documentId));
    await _questionnaireTemplateStore.update(
      await _db,
      questionnaire.toMap(),
      finder: finder,
    );
    await QuestionnaireTemplateCollection().updateQuestionnaire(questionnaire);
    return questionnaire;
  }

  static Future updateLocalOnly(Questionnaire questionnaire) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', questionnaire.documentId));
    await _questionnaireTemplateStore.update(
      await _db,
      questionnaire.toMap(),
      finder: finder,
    );
  }

  static Future delete(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _questionnaireTemplateStore.delete(
      await _db,
      finder: finder,
    );
    await QuestionnaireTemplateCollection().deleteQuestionnaire(documentId);
  }

  static Future<List<Questionnaire>?> getAll() async {
    final recordSnapshots = await _questionnaireTemplateStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final questionnaire = Questionnaire.fromMap(snapshot.value);
      questionnaire.id = snapshot.key;
      return questionnaire;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Questionnaire>? allLocalQuestionnaires = await getAll();
    List<Questionnaire>? allFireStoreQuestionnaires = await QuestionnaireTemplateCollection().getAll(UidUtil().getUid());

    if(allLocalQuestionnaires != null && allLocalQuestionnaires.isNotEmpty) {
      if(allFireStoreQuestionnaires != null && allFireStoreQuestionnaires.isNotEmpty) {
        //both local and fireStore have Questionnaires
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalQuestionnaires, allFireStoreQuestionnaires);
      } else {
        //all Questionnaires have been deleted in the cloud. Delete all local Questionnaires also.
        _deleteAllLocalQuestionnaires(allLocalQuestionnaires);
      }
    } else {
      if(allFireStoreQuestionnaires != null && allFireStoreQuestionnaires.isNotEmpty){
        //no local Questionnaires but there are fireStore Questionnaires.
        await _copyAllFireStoreQuestionnairesToLocal(allFireStoreQuestionnaires);
      } else {
        //no Questionnaires in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalQuestionnaires(List<Questionnaire> allLocalQuestionnaires) async {
    for(Questionnaire questionnaire in allLocalQuestionnaires) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', questionnaire.documentId));
      await _questionnaireTemplateStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreQuestionnairesToLocal(List<Questionnaire> allFireStoreQuestionnaires) async {
    for (Questionnaire QuestionnaireToSave in allFireStoreQuestionnaires) {
      await _questionnaireTemplateStore.add(await _db, QuestionnaireToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Questionnaire> allLocalQuestionnaires, List<Questionnaire> allFireStoreQuestionnaires) async {
    for(Questionnaire localQuestionnaire in allLocalQuestionnaires) {
      //should only be 1 matching
      List<Questionnaire> matchingFireStoreQuestionnaires = allFireStoreQuestionnaires.where((fireStoreQuestionnaire) => localQuestionnaire.documentId == fireStoreQuestionnaire.documentId).toList();
      if(matchingFireStoreQuestionnaires.isNotEmpty) {
        Questionnaire fireStoreQuestionnaire = matchingFireStoreQuestionnaires.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreQuestionnaire.documentId));
        await _questionnaireTemplateStore.update(
          await _db,
          fireStoreQuestionnaire.toMap(),
          finder: finder,
        );
      } else {
        //Questionnaire does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localQuestionnaire.documentId));
        await _questionnaireTemplateStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Questionnaire fireStoreQuestionnaire in allFireStoreQuestionnaires) {
      List<Questionnaire> matchingLocalQuestionnaires = allLocalQuestionnaires.where((localQuestionnaire) => localQuestionnaire.documentId == fireStoreQuestionnaire.documentId).toList();
      if(matchingLocalQuestionnaires.isNotEmpty) {
        //do nothing. Questionnaire already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreQuestionnaire.id = null;
        await _questionnaireTemplateStore.add(await _db, fireStoreQuestionnaire.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Questionnaire>? questionnaires = await getAll();
    _deleteAllLocalQuestionnaires(questionnaires!);
  }

  static void deleteAllRemote() async {
    List<Questionnaire>? questionnaires = await getAll();
    for(Questionnaire questionnaire in questionnaires!) {
      await delete(questionnaire.documentId);
    }
  }
}