import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Client.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class ClientDao extends Equatable{
  static const String CLIENT_STORE_NAME = 'clients';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _clientStore = intMapStoreFactory.store(CLIENT_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Client client) async {
    await _clientStore.add(await _db, client.toMap());
  }

  static Future insertOrUpdate(Client client) async {
    List<Client> clientList = await getAllSortedByFirstName();
    bool alreadyExists = false;
    for(Client singleClient in clientList){
      if(singleClient.id == client.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(client);
    }else{
      await insert(client);
    }
  }

  static Future update(Client client) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(client.id));
    await _clientStore.update(
      await _db,
      client.toMap(),
      finder: finder,
    );
  }

  static Future delete(Client client) async {
    final finder = Finder(filter: Filter.byKey(client.id));
    await _clientStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<Client>> getAllSortedByFirstName() async {
    final finder = Finder(sortOrders: [
      SortOrder('firstName'),
    ]);

    final recordSnapshots = await _clientStore.find(await _db, finder: finder);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final client = Client.fromMap(snapshot.value);
      client.id = snapshot.key;
      return client;
    }).toList();
  }

  static Future<Client> getClientById(int clientId) async{
    final finder = Finder(filter: Filter.byKey(clientId));
    final recordSnapshots = await _clientStore.find(await _db, finder: finder);
    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final client = Client.fromMap(snapshot.value);
      client.id = snapshot.key;
      return client;
    }).toList().elementAt(0);
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}