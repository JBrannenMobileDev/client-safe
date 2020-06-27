import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/utils/UidUtil.dart';

class ClientCollection {
  Future<void> createClient(Client client) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('clients')
        .add(client.toMap());
  }

  void deleteClient(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('clients')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Client> getUser(String documentId) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('clients')
        .document(documentId)
        .get()
        .then((client) => Client.fromMap(client.data, client.documentID));
  }

  Future<List<Client>> getAllUsersSortedByFirstName(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('clients')
        .getDocuments()
        .then((clients) => _buildClientsList(clients));
  }

  void updateUser(Client client) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('clients')
          .document(client.documentId)
          .updateData(client.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Client> _buildClientsList(QuerySnapshot clients) {
    List<Client> clientList = List();
    for(DocumentSnapshot clientDocument in clients.documents){
      clientList.add(Client.fromMap(clientDocument.data, clientDocument.documentID));
    }
    clientList.sort((clientA, clientB) => clientA.firstName.compareTo(clientB.firstName));
    return clientList;
  }
}