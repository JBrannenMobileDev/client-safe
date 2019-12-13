import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Location.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class LocationDao extends Equatable{
  static const String LOCATION_STORE_NAME = 'location';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  final _locationStore = intMapStoreFactory.store(LOCATION_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SembastDb.instance.database;

  Future insert(Location location) async {
    await _locationStore.add(await _db, location.toMap());
  }

  Future insertOrUpdate(Location location) async {
    List<Location> locationList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(Location singleLocation in locationList){
      if(singleLocation.id == location.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(location);
    }else{
      await insert(location);
    }
  }

  Future update(Location location) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationStore.update(
      await _db,
      location.toMap(),
      finder: finder,
    );
  }

  Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _locationStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Location>> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSessionsAtThisLocation'),
    ]);

    final recordSnapshots = await _locationStore.find(await _db, finder: finder);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final location = Location.fromMap(snapshot.value);
      location.id = snapshot.key;
      return location;
    }).toList();
  }
}