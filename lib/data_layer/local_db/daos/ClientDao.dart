import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/ClientCollection.dart';
import 'package:dandylight/models/Client.dart';

class ClientDao{
  static Future create(Client client) async {
    await ClientCollection().createClient(client);
  }

  static Future update(Client client) async {
    ClientCollection().updateUser(client);
  }

  static Future delete(Client client) async {
    ClientCollection().deleteClient(client.documentId);
  }

  static Future<List<Client>> getAllSortedByFirstName() async {

  }

  static Future<Client> getClientById(String documentId) async{

  }
}