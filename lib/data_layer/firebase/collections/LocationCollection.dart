import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/utils/UidUtil.dart';

class LocationCollection {
  void createLocation(Location location) {
    final databaseReference = Firestore.instance;
    databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .add(location.toMap());
  }

  void deleteJob(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
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
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .document(documentId)
        .get()
        .then((snapshot) => Location.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<Location>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('locations')
        .getDocuments()
        .then((jobs) => _buildLocationsList(jobs));
  }



  void updateLocation(Location location) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('locations')
          .document(location.documentId)
          .updateData(location.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Location> _buildLocationsList(QuerySnapshot jobs) {
    List<Location> locationsList = List();
    for(DocumentSnapshot jobSnapshot in jobs.documents){
      locationsList.add(Location.fromMap(jobSnapshot.data, jobSnapshot.documentID));
    }
    return locationsList;
  }
}