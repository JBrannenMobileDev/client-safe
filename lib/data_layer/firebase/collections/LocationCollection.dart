import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/utils/UidUtil.dart';

class LocationCollection {
  Future<void> createLocation(Location location) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .doc(location.documentId)
        .set(location.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('locations')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getLocationsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .snapshots();
  }

  Future<Location> getLocation(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .doc(documentId)
        .get()
        .then((locationSnapshot) {
          Location result = Location.fromMap(locationSnapshot.data());
          result.documentId = locationSnapshot.id;
          return result;
        });
  }

  Future<List<Location>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .get()
        .then((jobs) => _buildLocationsList(jobs));
  }



  Future<void> updateLocation(Location location) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('locations')
          .doc(location.documentId)
          .update(location.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Location> _buildLocationsList(QuerySnapshot locations) {
    List<Location> locationsList = List();
    for(DocumentSnapshot locationSnapshot in locations.docs){
      Location result = Location.fromMap(locationSnapshot.data());
      result.documentId = locationSnapshot.id;
      locationsList.add(result);
    }
    return locationsList;
  }
}