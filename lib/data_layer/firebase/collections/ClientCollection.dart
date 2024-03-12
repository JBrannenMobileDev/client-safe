import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class ClientCollection {
  Future<void> createClient(Client client) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('clients')
        .doc(client.documentId)
        .set(client.toMap())
        .catchError((error) {
          print(error);
        });
  }

  Stream<QuerySnapshot> getClientsStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('clients')
        .snapshots();
  }

  Future<void> deleteClient(String? documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('clients')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Client> getClient(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('clients')
        .doc(documentId)
        .get()
        .then((client) => Client.fromMap(client.data() as Map<String, dynamic>));
  }

  Future<List<Client>> getAllClientsSortedByFirstName(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('clients')
        .get()
        .then((clients) => _buildClientsList(clients));
  }

  Future<void> updateClient(Client client) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('clients')
          .doc(client.documentId)
          .update(client.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Client> _buildClientsList(QuerySnapshot clients) {
    List<Client> clientList = [];
    for(DocumentSnapshot clientDocument in clients.docs){
      Client result = Client.fromMap(clientDocument.data() as Map<String, dynamic>);
      result.documentId = clientDocument.id;
      clientList.add(result);
    }
    clientList.sort((clientA, clientB) => clientA.firstName.compareTo(clientB.firstName));
    return clientList;
  }
}