import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/ClientCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class ClientDao extends Equatable{
  static const String CLIENT_STORE_NAME = 'clients';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _clientStore = intMapStoreFactory.store(CLIENT_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future<String> insert(Client client) async {
    client.documentId = Uuid().v1();
    int savedClientId = await _clientStore.add(await _db, client.toMap());
    client.id = savedClientId;
    await ClientCollection().createClient(client);
    _updateLastChangedTime();
    return client.documentId;
  }

  static Future insertLocalOnly(Client client) async {
    client.id = null;
    await _clientStore.add(await _db, client.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.clientsLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(Client client) async {
    List<Client> clientList = await getAllSortedByFirstName();
    bool alreadyExists = false;
    for(Client singleClient in clientList){
      if(singleClient.documentId == client.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(client);
    }else{
      await insert(client);
    }
  }

  static Future<Stream<List<RecordSnapshot>>> getClientsStream() async {
    var query = _clientStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getClientsStreamFromFireStore() {
    return ClientCollection().getClientsStream();
  }

  static Future update(Client client) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', client.documentId));
    await _clientStore.update(
      await _db,
      client.toMap(),
      finder: finder,
    );
    await ClientCollection().updateClient(client);
    await client.jobs.forEach((job) async {
      job.client = client;
      job.clientName = client.getClientFullName();
      await JobDao.update(job);
    });
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(Client client) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', client.documentId));
    await _clientStore.update(
      await _db,
      client.toMap(),
      finder: finder,
    );
  }

  static Future delete(Client client) async {
    final finder = Finder(filter: Filter.equals('documentId', client.documentId));
    await _clientStore.delete(
      await _db,
      finder: finder,
    );
    await ClientCollection().deleteClient(client.documentId);
    _updateLastChangedTime();
  }

  static Future<Client> getClientByCreatedDate(DateTime createdDate) async{
    if((await getAll()).length > 0) {
      final recordSnapshots = await _clientStore.find(await _db);
      List<Client> clients = recordSnapshots.map((snapshot) {
        final client = Client.fromMap(snapshot.value);
        client.id = snapshot.key;
        return client;
      }).toList();
      for(Client savedClient in clients) {
        if(savedClient.createdDate.isAtSameMomentAs(createdDate)) {
          return savedClient;
        }
      }
      return null;
    } else {
      return null;
    }

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

  static Future<List<Client>> getAll() async {
    final recordSnapshots = await _clientStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final client = Client.fromMap(snapshot.value);
      client.id = snapshot.key;
      return client;
    }).toList();
  }

  static Future<Client> getClientById(String clientDocumentId) async{
    if((await getAll()).length > 0) {
      final finder = Finder(filter: Filter.equals('documentId', clientDocumentId));
      final recordSnapshots = await _clientStore.find(await _db, finder: finder);
      // Making a List<Client> out of List<RecordSnapshot>
      List<Client> clients = recordSnapshots.map((snapshot) {
        final client = Client.fromMap(snapshot.value);
        client.id = snapshot.key;
        return client;
      }).toList();
      return clients.isNotEmpty ? clients.elementAt(0) : null;
    } else {
      return null;
    }

  }
  
  static Future<void> syncAllFromFireStore() async {
    List<Client> allLocalClients = await getAll();
    List<Client> allFireStoreClients = await ClientCollection().getAllClientsSortedByFirstName(UidUtil().getUid());

    if(allLocalClients != null && allLocalClients.length > 0) {
      if(allFireStoreClients != null && allFireStoreClients.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalClients, allFireStoreClients);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalClients(allLocalClients);
      }
    } else {
      if(allFireStoreClients != null && allFireStoreClients.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreClientsToLocal(allFireStoreClients);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalClients(List<Client> allLocalClients) async {
    for(Client client in allLocalClients) {
      final finder = Finder(filter: Filter.equals('documentId', client.documentId));
      await _clientStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreClientsToLocal(List<Client> allFireStoreClients) async {
    for (Client clientToSave in allFireStoreClients) {
      await _clientStore.add(await _db, clientToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Client> allLocalClients, List<Client> allFireStoreClients) async {
    for(Client localClient in allLocalClients) {
      //should only be 1 matching
      List<Client> matchingFireStoreClients = allFireStoreClients.where((fireStoreClient) => localClient.documentId == fireStoreClient.documentId).toList();
      if(matchingFireStoreClients !=  null && matchingFireStoreClients.length > 0) {
        Client fireStoreClient = matchingFireStoreClients.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreClient.documentId));
        await _clientStore.update(
          await _db,
          fireStoreClient.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localClient.documentId));
        await _clientStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Client fireStoreClient in allFireStoreClients) {
      List<Client> matchingLocalClients = allLocalClients.where((localClient) => localClient.documentId == fireStoreClient.documentId).toList();
      if(matchingLocalClients != null && matchingLocalClients.length > 0) {
        //do nothing. Client already synced.
        //TODO even though client already exists, we still need to update it.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreClient.id = null;
        await _clientStore.add(await _db, fireStoreClient.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<Client> clients = await getAll();
    _deleteAllLocalClients(clients);
  }
}