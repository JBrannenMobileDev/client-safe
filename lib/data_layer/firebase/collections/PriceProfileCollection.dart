import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/utils/UidUtil.dart';

class PriceProfileCollection {
  Future<void> createPriceProfile(PriceProfile priceProfile) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .document(priceProfile.documentId)
        .setData(priceProfile.toMap());
  }

  Future<void> deletePriceProfile(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('priceProfiles')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<PriceProfile> getPriceProfile(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .document(documentId)
        .get()
        .then((priceProfileSnapshot) {
            PriceProfile profile = PriceProfile.fromMap(priceProfileSnapshot.data);
            profile.documentId = priceProfileSnapshot.documentID;
            return profile;
        });
  }

  Future<List<PriceProfile>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('priceProfiles')
        .getDocuments()
        .then((priceProfiles) => _buildPriceProfilesList(priceProfiles));
  }



  Future<void> updatePriceProfile(PriceProfile priceProfile) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
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
      PriceProfile profile = PriceProfile.fromMap(priceProfileSnapshot.data);
      profile.documentId = priceProfileSnapshot.documentID;
      priceProfilesList.add(profile);
    }
    return priceProfilesList;
  }
}