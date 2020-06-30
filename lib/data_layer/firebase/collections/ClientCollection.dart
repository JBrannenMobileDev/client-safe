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

  Future<void> deleteClient(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('clients')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Client> getClient(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('clients')
        .document(documentId)
        .get()
        .then((client) {
          Client result = Client.fromMap(client.data);
          result.documentId = client.documentID;
          return result;
        });
  }

  Future<List<Client>> getAllClientsSortedByFirstName(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('clients')
        .getDocuments()
        .then((clients) => _buildClientsList(clients));
  }

  Future<void> updateClient(Client client) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
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
      Client result = Client.fromMap(clientDocument.data);
      result.documentId = clientDocument.documentID;
      clientList.add(result);
    }
    clientList.sort((clientA, clientB) => clientA.firstName.compareTo(clientB.firstName));
    return clientList;
  }
}