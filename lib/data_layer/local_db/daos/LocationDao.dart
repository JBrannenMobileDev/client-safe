import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/LocationCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
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

  static Future<Location> insert(Location location) async {
    location.documentId = Uuid().v1();
    location.id = await _locationStore.add(await _db, location.toMap());
    await LocationCollection().createLocation(location);
    _updateLastChangedTime();
    return location;
  }

  static Future insertLocalOnly(Location location) async {
    location.id = null;
    await _locationStore.add(await _db, location.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.locationsLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future<Location> insertOrUpdate(Location location) async {
    List<Location> locationList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(Location singleLocation in locationList){
      if(singleLocation.documentId == location.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(location);
    }else{
      return await insert(location);
    }
  }

  static Future<Location> getById(String locationDocumentId) async{
    if((await getAllSortedMostFrequent()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', locationDocumentId));
      final recordSnapshots = await _locationStore.find(await _db, finder: finder);
      // Making a List<profileId> out of List<RecordSnapshot>
      List<Location> locations = recordSnapshots.map((snapshot) {
        final location = Location.fromMap(snapshot.value);
        location.id = snapshot.key;
        return location;
      }).toList();
      if(locations.isNotEmpty) {
        return locations.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Stream<List<RecordSnapshot>>> getLocationsStream() async {
    var query = _locationStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getLocationsStreamFromFireStore() {
    return LocationCollection().getLocationsStream();
  }

  static Future<Location> update(Location location) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', location.documentId));
    await _locationStore.update(
      await _db,
      location.toMap(),
      finder: finder,
    );
    await LocationCollection().updateLocation(location);
    _updateLastChangedTime();
    return location;
  }

  static Future updateLocalOnly(Location location) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', location.documentId));
    await _locationStore.update(
      await _db,
      location.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _locationStore.delete(
      await _db,
      finder: finder,
    );
    await LocationCollection().deleteJob(documentId);
    await FileStorage.deleteLocationFileImage(await getById(documentId));
    _updateLastChangedTime();

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

  static Future<void> syncAllFromFireStore() async {
    List<Location> allLocalLocations = await getAllSortedMostFrequent();
    List<Location> allFireStoreLocations = await LocationCollection().getAll(UidUtil().getUid());

    if(allLocalLocations != null && allLocalLocations.length > 0) {
      if(allFireStoreLocations != null && allFireStoreLocations.length > 0) {
        //both local and fireStore have Locations
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalLocations, allFireStoreLocations);
      } else {
        //all Locations have been deleted in the cloud. Delete all local Locations also.
        _deleteAllLocalLocations(allLocalLocations);
      }
    } else {
      if(allFireStoreLocations != null && allFireStoreLocations.length > 0){
        //no local Locations but there are fireStore Locations.
        await _copyAllFireStoreLocationsToLocal(allFireStoreLocations);
      } else {
        //no Locations in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalLocations(List<Location> allLocalLocations) async {
    for(Location location in allLocalLocations) {
      final finder = Finder(filter: Filter.equals('documentId', location.documentId));
      await _locationStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreLocationsToLocal(List<Location> allFireStoreLocations) async {
    for (Location LocationToSave in allFireStoreLocations) {
      await _locationStore.add(await _db, LocationToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Location> allLocalLocations, List<Location> allFireStoreLocations) async {
    for(Location localLocation in allLocalLocations) {
      //should only be 1 matching
      List<Location> matchingFireStoreLocations = allFireStoreLocations.where((fireStoreLocation) => localLocation.documentId == fireStoreLocation.documentId).toList();
      if(matchingFireStoreLocations !=  null && matchingFireStoreLocations.length > 0) {
        Location fireStoreLocation = matchingFireStoreLocations.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreLocation.documentId));
        await _locationStore.update(
          await _db,
          fireStoreLocation.toMap(),
          finder: finder,
        );
      } else {
        //Location does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localLocation.documentId));
        await _locationStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Location fireStoreLocation in allFireStoreLocations) {
      List<Location> matchingLocalLocations = allLocalLocations.where((localLocation) => localLocation.documentId == fireStoreLocation.documentId).toList();
      if(matchingLocalLocations != null && matchingLocalLocations.length > 0) {
        //do nothing. Location already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreLocation.id = null;
        await _locationStore.add(await _db, fireStoreLocation.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Location> locations = await getAllSortedMostFrequent();
    _deleteAllLocalLocations(locations);
  }

  static void deleteAllRemote() async {
    List<Location> locations = await getAllSortedMostFrequent();
    for(Location location in locations) {
      await delete(location.documentId);
    }
  }
}