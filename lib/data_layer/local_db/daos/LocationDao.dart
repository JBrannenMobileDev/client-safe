import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/LocationCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Location.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class LocationDao extends Equatable{
  static const String LOCATION_STORE_NAME = 'location';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _locationStore = intMapStoreFactory.store(LOCATION_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Location location) async {
    location.documentId = Uuid().v1();
    location.id = await _locationStore.add(await _db, location.toMap());
    await LocationCollection().createLocation(location);
  }

  static Future insertOrUpdate(Location location) async {
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

  static Future update(Location location) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(location.id));
    await _locationStore.update(
      await _db,
      location.toMap(),
      finder: finder,
    );
    await LocationCollection().updateLocation(location);
  }

  static Future delete(int id, String documentId) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _locationStore.delete(
      await _db,
      finder: finder,
    );
    await LocationCollection().deleteJob(documentId);
  }

  static Future<List<Location>> getAllSortedMostFrequent() async {
    final finder = Finder(sortOrders: [
      SortOrder('numOfSessionsAtThisLocation'),
    ]);

    final recordSnapshots = await _locationStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final location = Location.fromMap(snapshot.value);
      location.id = snapshot.key;
      return location;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}