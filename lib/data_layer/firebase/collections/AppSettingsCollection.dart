import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/AppSettings.dart';

import '../../../utils/EnvironmentUtil.dart';

class AppSettingsCollection {
  Future<void> createAppSettings(AppSettings appSettings) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('appSettings')
        .doc(appSettings.documentId)
        .set(appSettings.toMap());
  }

  Future<void> delete(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('appSettings')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<AppSettings> get(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('appSettings')
        .doc(documentId)
        .get()
        .then((contractSnapshot) {
          AppSettings result = AppSettings.fromMap(contractSnapshot.data());
          result.documentId = contractSnapshot.id;
          return result;
        });
  }

  Future<List<AppSettings>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('appSettings')
        .get()
        .then((appSettings) => _buildContractsList(appSettings));
  }



  Future<void> update(AppSettings appSettings) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('appSettings')
          .doc(appSettings.documentId)
          .update(appSettings.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<AppSettings> _buildContractsList(QuerySnapshot contracts) {
    List<AppSettings> list = [];
    for(DocumentSnapshot contractSnapshot in contracts.docs){
      AppSettings result = AppSettings.fromMap(contractSnapshot.data());
      result.documentId = contractSnapshot.id;
      list.add(result);
    }
    return list;
  }
}