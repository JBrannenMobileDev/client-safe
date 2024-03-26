import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/Contract.dart';
import '../../../utils/EnvironmentUtil.dart';

class ContractCollection {
  Future<void> createContract(Contract contract) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('contracts')
        .doc(contract.documentId)
        .set(contract.toMap());
  }

  Future<void> deleteJob(String? documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('contracts')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getContractsStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('contracts')
        .snapshots();
  }

  Future<Contract> getContract(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('contracts')
        .doc(documentId)
        .get()
        .then((contractSnapshot) {
          Contract result = Contract.fromMap(contractSnapshot.data() as Map<String, dynamic>);
          result.documentId = contractSnapshot.id;
          return result;
        });
  }

  Future<List<Contract>?> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('contracts')
        .get()
        .then((jobs) => _buildContractsList(jobs));
  }



  Future<void> updateContract(Contract contract) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('contracts')
          .doc(contract.documentId)
          .update(contract.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Contract> _buildContractsList(QuerySnapshot contracts) {
    List<Contract> contractsList = [];
    for(DocumentSnapshot contractSnapshot in contracts.docs){
      Contract result = Contract.fromMap(contractSnapshot.data() as Map<String, dynamic>);
      result.documentId = contractSnapshot.id;
      contractsList.add(result);
    }
    return contractsList;
  }
}