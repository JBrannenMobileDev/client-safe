import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:equatable/equatable.dart';
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
  }

  static Future insertOrUpdate(Profile profile) async {
    List<Profile> profileList = await getAllSortedByFirstName();
    bool alreadyExists = false;
    for(Profile singleProfile in profileList){
      if(singleProfile.id == profile.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(profile);
    }else{
      await insert(profile);
    }
  }

  static Future update(Profile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(profile.id));
    await _profileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
    await UserCollection().updateUser(profile);
  }

  static Future delete(Profile profile) async {
    final finder = Finder(filter: Filter.byKey(profile.id));
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

  @override
  // TODO: implement props
  List<Object> get props => [];
}