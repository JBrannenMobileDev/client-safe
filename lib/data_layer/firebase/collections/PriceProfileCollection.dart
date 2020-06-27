import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/utils/UidUtil.dart';

class PriceProfileCollection {
  Future<void> createJob(PriceProfile priceProfile) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .add(priceProfile.toMap());
  }

  void deleteJob(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('priceProfiles')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<PriceProfile> getJob(String documentId) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .document(documentId)
        .get()
        .then((snapshot) => PriceProfile.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<PriceProfile>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .getDocuments()
        .then((priceProfiles) => _buildPriceProfilesList(priceProfiles));
  }



  void updateJob(PriceProfile priceProfile) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('priceProfiles')
          .document(priceProfile.documentId)
          .updateData(priceProfile.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<PriceProfile> _buildPriceProfilesList(QuerySnapshot jobs) {
    List<PriceProfile> priceProfilesList = List();
    for(DocumentSnapshot priceProfileSnapshot in jobs.documents){
      priceProfilesList.add(PriceProfile.fromMap(priceProfileSnapshot.data, priceProfileSnapshot.documentID));
    }
    return priceProfilesList;
  }
}