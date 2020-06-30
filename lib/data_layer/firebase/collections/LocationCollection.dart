import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/utils/UidUtil.dart';

class LocationCollection {
  Future<void> createLocation(Location location) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .add(location.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('locations')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Location> getLocation(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .document(documentId)
        .get()
        .then((locationSnapshot) {
          Location result = Location.fromMap(locationSnapshot.data);
          result.documentId = locationSnapshot.documentID;
          return result;
        });
  }

  Future<List<Location>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .getDocuments()
        .then((jobs) => _buildLocationsList(jobs));
  }



  Future<void> updateLocation(Location location) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('locations')
          .document(location.documentId)
          .updateData(location.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Location> _buildLocationsList(QuerySnapshot locations) {
    List<Location> locationsList = List();
    for(DocumentSnapshot locationSnapshot in locations.documents){
      Location result = Location.fromMap(locationSnapshot.data);
      result.documentId = locationSnapshot.documentID;
      locationsList.add(result);
    }
    return locationsList;
  }
}