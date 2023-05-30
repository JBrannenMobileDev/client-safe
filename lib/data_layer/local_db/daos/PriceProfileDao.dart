import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/PriceProfileCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class PriceProfileDao extends Equatable{
  static const String PRICE_PROFILE_STORE_NAME = 'priceProfile';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _priceProfileStore = intMapStoreFactory.store(PRICE_PROFILE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(PriceProfile profile) async {
    profile.documentId = Uuid().v1();
    profile.id = await _priceProfileStore.add(await _db, profile.toMap());
    await PriceProfileCollection().createPriceProfile(profile);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.priceProfilesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocalOnly(PriceProfile profile) async {
    profile.id = null;
    await _priceProfileStore.add(await _db, profile.toMap());
  }

  static Future insertOrUpdate(PriceProfile profile) async {
    List<PriceProfile> profileList = await getAllSortedByName();
    bool alreadyExists = false;
    for(PriceProfile singleProfile in profileList){
      if(singleProfile.documentId == profile.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(profile);
    }else{
      await insert(profile);
    }
  }

  static Future<PriceProfile> getById(String profileDocumentId) async{
    if((await getAllSortedByName()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', profileDocumentId));
      final recordSnapshots = await _priceProfileStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<PriceProfile> list = recordSnapshots.map((snapshot) {
        final profile = PriceProfile.fromMap(snapshot.value);
        profile.id = snapshot.key;
        return profile;
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

  static Future<Stream<List<RecordSnapshot>>> getPriceProfilesStream() async {
    var query = _priceProfileStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getPriceProfilesStreamFromFireStore() {
    return PriceProfileCollection().getPriceProfilesStream();
  }

  static Future update(PriceProfile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', profile.documentId));
    await _priceProfileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
    await PriceProfileCollection().updatePriceProfile(profile);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(PriceProfile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', profile.documentId));
    await _priceProfileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
  }

  static Future delete(PriceProfile profile) async {
    final finder = Finder(filter: Filter.equals('documentId', profile.documentId));
    await _priceProfileStore.delete(
      await _db,
      finder: finder,
    );
    await PriceProfileCollection().deletePriceProfile(profile.documentId);
    _updateLastChangedTime();
  }

  static Future<List<PriceProfile>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [
      SortOrder('profileName'),
    ]);

    final recordSnapshots = await _priceProfileStore.find(await _db, finder: finder);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final profile = PriceProfile.fromMap(snapshot.value);
      profile.id = snapshot.key;
      return profile;
    }).toList();
  }

  static Future<void> syncAllFromFireStore() async {
    List<PriceProfile> allLocalPriceProfiles = await getAllSortedByName();
    List<PriceProfile> allFireStorePriceProfiles = await PriceProfileCollection().getAll(UidUtil().getUid());

    if(allLocalPriceProfiles != null && allLocalPriceProfiles.length > 0) {
      if(allFireStorePriceProfiles != null && allFireStorePriceProfiles.length > 0) {
        //both local and fireStore have PriceProfiles
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalPriceProfiles, allFireStorePriceProfiles);
      } else {
        //all PriceProfiles have been deleted in the cloud. Delete all local PriceProfiles also.
        _deleteAllLocalPriceProfiles(allLocalPriceProfiles);
      }
    } else {
      if(allFireStorePriceProfiles != null && allFireStorePriceProfiles.length > 0){
        //no local PriceProfiles but there are fireStore PriceProfiles.
        await _copyAllFireStorePriceProfilesToLocal(allFireStorePriceProfiles);
      } else {
        //no PriceProfiles in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalPriceProfiles(List<PriceProfile> allLocalPriceProfiles) async {
    for(PriceProfile priceProfile in allLocalPriceProfiles) {
      final finder = Finder(filter: Filter.equals('documentId', priceProfile.documentId));
      await _priceProfileStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStorePriceProfilesToLocal(List<PriceProfile> allFireStorePriceProfiles) async {
    for (PriceProfile PriceProfileToSave in allFireStorePriceProfiles) {
      await _priceProfileStore.add(await _db, PriceProfileToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<PriceProfile> allLocalPriceProfiles, List<PriceProfile> allFireStorePriceProfiles) async {
    for(PriceProfile localPriceProfile in allLocalPriceProfiles) {
      //should only be 1 matching
      List<PriceProfile> matchingFireStorePriceProfiles = allFireStorePriceProfiles.where((fireStorePriceProfile) => localPriceProfile.documentId == fireStorePriceProfile.documentId).toList();
      if(matchingFireStorePriceProfiles !=  null && matchingFireStorePriceProfiles.length > 0) {
        PriceProfile fireStorePriceProfile = matchingFireStorePriceProfiles.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStorePriceProfile.documentId));
        await _priceProfileStore.update(
          await _db,
          fireStorePriceProfile.toMap(),
          finder: finder,
        );
      } else {
        //PriceProfile does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localPriceProfile.documentId));
        await _priceProfileStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(PriceProfile fireStorePriceProfile in allFireStorePriceProfiles) {
      List<PriceProfile> matchingLocalPriceProfiles = allLocalPriceProfiles.where((localPriceProfile) => localPriceProfile.documentId == fireStorePriceProfile.documentId).toList();
      if(matchingLocalPriceProfiles != null && matchingLocalPriceProfiles.length > 0) {
        //do nothing. PriceProfile already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStorePriceProfile.id = null;
        await _priceProfileStore.add(await _db, fireStorePriceProfile.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<PriceProfile> profiles = await getAllSortedByName();
    _deleteAllLocalPriceProfiles(profiles);
  }

  static getByNameAndPrice(String profileName, double flatRate) async {
    List<PriceProfile> all = await getAllSortedByName();
    for(PriceProfile profile in all) {
      if(profile.profileName == profileName && profile.flatRate == flatRate) return profile;
    }
    return null;
  }
}