import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sembast/sembast.dart';

class ProfileDao extends Equatable{
  static const String PROFILE_STORE_NAME = 'profile';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _profileStore = intMapStoreFactory.store(PROFILE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Profile profile) async {
    await _profileStore.add(await _db, profile.toMap());
    await UserCollection().createUser(profile);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    List<Profile> profiles = await ProfileDao.getAll();
    if(profiles != null && profiles.isNotEmpty) {
      Profile profile = profiles.elementAt(0);
      profile.profileLastChangeDate = DateTime.now();
      final finder = Finder(filter: Filter.equals('uid', profile.uid));
      await _profileStore.update(
        await _db,
        profile.toMap(),
        finder: finder,
      );
      await UserCollection().updateUser(profile);
    }
  }

  static Future insertLocal(Profile profile) async {
    profile.id = null;
    await _profileStore.add(await _db, profile.toMap());
  }

  static Future insertOrUpdate(Profile profile) async {
    List<Profile> profileList = await getAllSortedByFirstName();
    bool alreadyExists = false;
    for(Profile singleProfile in profileList){
      if(singleProfile.uid == profile.uid){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(profile);
      if((await UserCollection().getUser(UidUtil().getUid())) == null) {
        await UserCollection().createUser(profile);
      }
    }else{
      await insert(profile);
    }
  }

  static Future update(Profile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('uid', profile.uid));
    await _profileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
    await UserCollection().updateUser(profile);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(Profile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('uid', profile.uid));
    await _profileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
  }

  static Future delete(Profile profile) async {
    final finder = Finder(filter: Filter.equals('uid', profile.uid));
    await _profileStore.delete(
      await _db,
      finder: finder,
    );
    await UserCollection().deleteUser(profile.uid);
  }

  static Future<List<Profile>> getAllSortedByFirstName() async {
    final finder = Finder(sortOrders: [
      SortOrder('firstName'),
    ]);

    final recordSnapshots = await _profileStore.find(await _db, finder: finder);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final profile = Profile.fromMap(snapshot.value);
      profile.id = snapshot.key;
      return profile;
    }).toList();
  }

  static Future<List<Profile>> getAll() async {
    final recordSnapshots = await _profileStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final profile = Profile.fromMap(snapshot.value);
      profile.id = snapshot.key;
      return profile;
    }).toList();
  }

  static Future<void> updateUserLoginTime(String uid) async{
    List<Profile> userProfiles = await ProfileDao.getAll();
    if (userProfiles.isNotEmpty) {
      Profile fireStoreProfile = await UserCollection().getUser(uid);
      DateTime now = DateTime.now();
      if(now.millisecondsSinceEpoch > (fireStoreProfile.lastSignIn ?? DateTime.utc(1971)).millisecondsSinceEpoch) {
        Profile updatedProfile = userProfiles.elementAt(0).copyWith(
          uid: uid,
          lastSignIn: now,
          clientsLastChangeDate: fireStoreProfile.clientsLastChangeDate,
          invoicesLastChangeDate: fireStoreProfile.invoicesLastChangeDate,
          jobsLastChangeDate: fireStoreProfile.jobsLastChangeDate,
          locationsLastChangeDate: fireStoreProfile.locationsLastChangeDate,
          mileageExpensesLastChangeDate: fireStoreProfile.mileageExpensesLastChangeDate,
          priceProfilesLastChangeDate: fireStoreProfile.priceProfilesLastChangeDate,
          recurringExpensesLastChangeDate: fireStoreProfile.recurringExpensesLastChangeDate,
          singleExpensesLastChangeDate: fireStoreProfile.singleExpensesLastChangeDate,
          responsesLastChangeDate: fireStoreProfile.responsesLastChangeDate,
        );
        ProfileDao.insertOrUpdate(updatedProfile);
      }
    }
  }

  static syncAllFromFireStore() async {
    Profile fireStoreProfile = await UserCollection().getUser(UidUtil().getUid());
    await updateLocalOnly(fireStoreProfile);
  }

  static Future<Stream<List<RecordSnapshot>>> getProfileStream() async {
    var query = _profileStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<DocumentSnapshot> getProfileStreamFromFireStore() {
    return UserCollection().getProfileStream();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllProfilesLocal() async {
    List<Profile> profiles = await getAll();

    for(Profile profile in profiles) {
        final finder = Finder(filter: Filter.equals('uid', profile.uid));
        await _profileStore.delete(
          await _db,
          finder: finder,
        );
    }
  }

  static Future<Profile> getMatchingProfile(String uid) async {
    List<Profile> profiles = await getAll();
    Profile result = null;
    for(Profile profile in profiles) {
      if(profile.uid == uid) {
        result = profile;
      }
    }
    return result;
  }
}