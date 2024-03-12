import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import '../../../models/AppSettings.dart';
import '../../firebase/collections/AppSettingsCollection.dart';

class AppSettingsDao extends Equatable{
  static const String APP_SETTINGS_STORE_NAME = 'appSettings';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _appSettingsStore = sembast.intMapStoreFactory.store(APP_SETTINGS_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<AppSettings> insert(AppSettings settings) async {
    settings.documentId = Uuid().v1();
    settings.id = await _appSettingsStore.add(await _db, settings.toMap());
    await AppSettingsCollection().createAppSettings(settings);
    return settings;
  }

  static Future insertLocalOnly(AppSettings contract) async {
    contract.id = null;
    await _appSettingsStore.add(await _db, contract.toMap());
  }

  static Future<AppSettings> insertOrUpdate(AppSettings contract) async {
    List<AppSettings> contractList = await getAll();
    bool alreadyExists = false;
    for(AppSettings singleAppSettings in contractList){
      if(singleAppSettings.documentId == contract.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(contract);
    }else{
      return await insert(contract);
    }
  }

  static Future<AppSettings?> getById(String contractDocumentId) async{
    if((await getAll()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contractDocumentId));
      final recordSnapshots = await _appSettingsStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<AppSettings> contracts = recordSnapshots.map((snapshot) {
        final contract = AppSettings.fromMap(snapshot.value);
        contract.id = snapshot.key;
        return contract;
      }).toList();
      if(contracts.isNotEmpty) {
        return contracts.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<AppSettings> update(AppSettings contract) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
    await _appSettingsStore.update(
      await _db,
      contract.toMap(),
      finder: finder,
    );
    await AppSettingsCollection().update(contract);
    return contract;
  }

  static Future updateLocalOnly(AppSettings contract) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
    await _appSettingsStore.update(
      await _db,
      contract.toMap(),
      finder: finder,
    );
  }

  static Future delete(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    int countOfUpdatedItems = await _appSettingsStore.delete(
      await _db,
      finder: finder,
    );
    await AppSettingsCollection().delete(documentId);
  }

  static Future<List<AppSettings>> getAll() async {
    final recordSnapshots = await _appSettingsStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final contract = AppSettings.fromMap(snapshot.value);
      contract.id = snapshot.key;
      return contract;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<AppSettings> allLocalAppSettingss = await getAll();
    List<AppSettings> allFireStoreAppSettingss = await AppSettingsCollection().getAll(UidUtil().getUid());

    if(allLocalAppSettingss != null && allLocalAppSettingss.length > 0) {
      if(allFireStoreAppSettingss != null && allFireStoreAppSettingss.length > 0) {
        //both local and fireStore have AppSettingss
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalAppSettingss, allFireStoreAppSettingss);
      } else {
        //all AppSettingss have been deleted in the cloud. Delete all local AppSettingss also.
        _deleteAllLocalAppSettingss(allLocalAppSettingss);
      }
    } else {
      if(allFireStoreAppSettingss != null && allFireStoreAppSettingss.length > 0){
        //no local AppSettingss but there are fireStore AppSettingss.
        await _copyAllFireStoreAppSettingssToLocal(allFireStoreAppSettingss);
      } else {
        //no AppSettingss in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalAppSettingss(List<AppSettings> allLocalAppSettingss) async {
    for(AppSettings contract in allLocalAppSettingss) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', contract.documentId));
      await _appSettingsStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreAppSettingssToLocal(List<AppSettings> allFireStoreAppSettingss) async {
    for (AppSettings AppSettingsToSave in allFireStoreAppSettingss) {
      await _appSettingsStore.add(await _db, AppSettingsToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<AppSettings> allLocalAppSettingss, List<AppSettings> allFireStoreAppSettingss) async {
    for(AppSettings localAppSettings in allLocalAppSettingss) {
      //should only be 1 matching
      List<AppSettings> matchingFireStoreAppSettingss = allFireStoreAppSettingss.where((fireStoreAppSettings) => localAppSettings.documentId == fireStoreAppSettings.documentId).toList();
      if(matchingFireStoreAppSettingss !=  null && matchingFireStoreAppSettingss.length > 0) {
        AppSettings fireStoreAppSettings = matchingFireStoreAppSettingss.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreAppSettings.documentId));
        await _appSettingsStore.update(
          await _db,
          fireStoreAppSettings.toMap(),
          finder: finder,
        );
      } else {
        //AppSettings does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localAppSettings.documentId));
        await _appSettingsStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(AppSettings fireStoreAppSettings in allFireStoreAppSettingss) {
      List<AppSettings> matchingLocalAppSettingss = allLocalAppSettingss.where((localAppSettings) => localAppSettings.documentId == fireStoreAppSettings.documentId).toList();
      if(matchingLocalAppSettingss != null && matchingLocalAppSettingss.length > 0) {
        //do nothing. AppSettings already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreAppSettings.id = null;
        await _appSettingsStore.add(await _db, fireStoreAppSettings.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<AppSettings> contracts = await getAll();
    _deleteAllLocalAppSettingss(contracts);
  }

  static void deleteAllRemote() async {
    List<AppSettings> contracts = await getAll();
    for(AppSettings contract in contracts) {
      await delete(contract.documentId);
    }
  }
}