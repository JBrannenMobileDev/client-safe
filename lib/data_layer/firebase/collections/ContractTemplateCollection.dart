import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/Contract.dart';
import '../../../utils/EnvironmentUtil.dart';

class ContractTemplateCollection {
  Future<void> createContract(Contract contract) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('contractTemplates')
        .doc(contract.documentId)
        .set(contract.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('contractTemplates')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Contract> getContract(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('contractTemplates')
        .doc(documentId)
        .get()
        .then((contractSnapshot) {
          Contract result = Contract.fromMap(contractSnapshot.data());
          result.documentId = contractSnapshot.id;
          return result;
        });
  }

  Future<List<Contract>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('contractTemplates')
        .get()
        .then((jobs) => _buildContractsList(jobs));
  }



  Future<void> updateContract(Contract contract) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('contractTemplates')
          .doc(contract.documentId)
          .update(contract.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Contract> _buildContractsList(QuerySnapshot contracts) {
    List<Contract> contractsList = [];
    for(DocumentSnapshot contractSnapshot in contracts.docs){
      Contract result = Contract.fromMap(contractSnapshot.data());
      result.documentId = contractSnapshot.id;
      contractsList.add(result);
    }
    return contractsList;
  }
}