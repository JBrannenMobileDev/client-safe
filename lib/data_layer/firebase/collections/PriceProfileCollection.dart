import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class PriceProfileCollection {
  Future<void> createPriceProfile(PriceProfile priceProfile) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('priceProfiles')
        .doc(priceProfile.documentId)
        .set(priceProfile.toMap());
  }

  Future<void> deletePriceProfile(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('priceProfiles')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getPriceProfilesStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('priceProfiles')
        .snapshots();
  }

  Future<PriceProfile> getPriceProfile(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('priceProfiles')
        .doc(documentId)
        .get()
        .then((priceProfileSnapshot) {
            PriceProfile profile = PriceProfile.fromMap(priceProfileSnapshot.data() as Map<String, dynamic>);
            profile.documentId = priceProfileSnapshot.id;
            return profile;
        });
  }

  Future<List<PriceProfile>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('priceProfiles')
        .get()
        .then((priceProfiles) => _buildPriceProfilesList(priceProfiles));
  }



  Future<void> updatePriceProfile(PriceProfile priceProfile) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('priceProfiles')
          .doc(priceProfile.documentId)
          .update(priceProfile.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<PriceProfile> _buildPriceProfilesList(QuerySnapshot jobs) {
    List<PriceProfile> priceProfilesList = [];
    for(DocumentSnapshot priceProfileSnapshot in jobs.docs){
      PriceProfile profile = PriceProfile.fromMap(priceProfileSnapshot.data() as Map<String, dynamic>);
      profile.documentId = priceProfileSnapshot.id;
      priceProfilesList.add(profile);
    }
    return priceProfilesList;
  }
}