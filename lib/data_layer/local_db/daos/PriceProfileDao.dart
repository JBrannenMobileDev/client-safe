import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class PriceProfileDao extends Equatable{
  static const String PRICE_PROFILE_STORE_NAME = 'priceProfile';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _priceProfileStore = intMapStoreFactory.store(PRICE_PROFILE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(PriceProfile profile) async {
    await _priceProfileStore.add(await _db, profile.toMap());
  }

  static Future insertOrUpdate(PriceProfile profile) async {
    List<PriceProfile> profileList = await getAllSortedByName();
    bool alreadyExists = false;
    for(PriceProfile singleProfile in profileList){
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

  static Future update(PriceProfile profile) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(profile.id));
    await _priceProfileStore.update(
      await _db,
      profile.toMap(),
      finder: finder,
    );
  }

  static Future delete(PriceProfile profile) async {
    final finder = Finder(filter: Filter.byKey(profile.id));
    await _priceProfileStore.delete(
      await _db,
      finder: finder,
    );
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

  @override
  // TODO: implement props
  List<Object> get props => [];
}