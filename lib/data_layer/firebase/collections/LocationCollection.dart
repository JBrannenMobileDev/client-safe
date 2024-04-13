import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class LocationCollection {
  Future<void> createLocation(LocationDandy location) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
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
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
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
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .snapshots();
  }

  Future<LocationDandy> getLocation(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .doc(documentId)
        .get()
        .then((locationSnapshot) {
          LocationDandy result = LocationDandy.fromMap(locationSnapshot.data() as Map<String, dynamic>);
          result.documentId = locationSnapshot.id;
          return result;
        });
  }

  Future<List<LocationDandy>?> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('locations')
        .get()
        .then((jobs) => _buildLocationsList(jobs));
  }



  Future<void> updateLocation(LocationDandy location) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('locations')
          .doc(location.documentId)
          .update(location.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<LocationDandy> _buildLocationsList(QuerySnapshot locations) {
    List<LocationDandy> locationsList = [];
    for(DocumentSnapshot locationSnapshot in locations.docs){
      LocationDandy result = LocationDandy.fromMap(locationSnapshot.data() as Map<String, dynamic>);
      result.documentId = locationSnapshot.id;
      locationsList.add(result);
    }
    return locationsList;
  }
}