import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Response.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class ResponseCollection {
  Future<void> createResponse(Response response) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('responses')
        .doc(response.documentId)
        .set(response.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteResponse(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('responses')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getResponseStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('responses')
        .snapshots();
  }

  Future<Response> getResponse(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('responses')
        .doc(documentId)
        .get()
        .then((responseSnapshot) {
          Response response = Response.fromMap(responseSnapshot.data());
          response.documentId = responseSnapshot.id;
          return response;
        });
  }

  Future<List<Response>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('responses')
        .get()
        .then((response) => _buildResponsesList(response));
  }



  Future<void> updateResponse(Response response) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('responses')
          .doc(response.documentId)
          .update(response.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Response> _buildResponsesList(QuerySnapshot jobs) {
    List<Response> responsesList = [];
    for(DocumentSnapshot responseSnapshot in jobs.docs){
      Response response = Response.fromMap(responseSnapshot.data());
      response.documentId = responseSnapshot.id;
      responsesList.add(response);
    }
    return responsesList;
  }
}