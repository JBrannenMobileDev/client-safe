import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';

class FireStoreSync {
    
    Future<void> dandyLightAppInitializationSync() async {
        List<Profile> users = await ProfileDao.getAll();
        if(users.length > 0) {
            Profile userLocalDb = users.elementAt(0);
            Profile userFireStoreDb = await UserCollection().getUser(UidUtil().getUid());
            if(userLocalDb != null && userFireStoreDb != null) {
                await _syncClients(userLocalDb, userFireStoreDb);
                await _syncInvoices(userLocalDb, userFireStoreDb);
                await _syncJobs(userLocalDb, userFireStoreDb);
                await _syncLocations(userLocalDb, userFireStoreDb);
                await _syncMileageExpenses(userLocalDb, userFireStoreDb);
                await _syncPriceProfiles(userLocalDb, userFireStoreDb);
                await _syncRecurringExpenses(userLocalDb, userFireStoreDb);
                await _syncSingleExpenses(userLocalDb, userFireStoreDb);
            }
        }
        setupFireStoreListeners();
    }

    Future<void> setupFireStoreListeners () async {
        ClientDao.getClientsStreamFromFireStore()
            .listen((snapshots) async {
                for(DocumentChange snapshot in snapshots.documentChanges) {
                    Client client = Client.fromMap(snapshot.document.data);
                    Client clientFromLocal = await ClientDao.getClientById(client.id);
                    if(clientFromLocal != null) {
                        ClientDao.updateLocalOnly(client);
                    }else {
                        ClientDao.insertLocalOnly(client);
                    }
                }
        });

        PriceProfileDao.getPriceProfilesStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                PriceProfile priceProfile = PriceProfile.fromMap(snapshot.document.data);
                PriceProfile priceProfileFromLocal = await PriceProfileDao.getById(priceProfile.id);
                if(priceProfileFromLocal != null) {
                    PriceProfileDao.updateLocalOnly(priceProfile);
                }else {
                    PriceProfileDao.insertLocalOnly(priceProfile);
                }
            }
        });

        LocationDao.getLocationsStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                Location location = Location.fromMap(snapshot.document.data);
                Location locationFromLocal = await LocationDao.getById(location.id);
                if(locationFromLocal != null) {
                    LocationDao.updateLocalOnly(location);
                }else {
                    LocationDao.insertLocalOnly(location);
                }
            }
        });
    }

    Future<void> _syncClients(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.clientsLastChangeDate != userFireStoreDb.clientsLastChangeDate) || (userLocalDb.clientsLastChangeDate == null && userFireStoreDb.clientsLastChangeDate != null)) {
            if(userLocalDb.clientsLastChangeDate != null && userFireStoreDb.clientsLastChangeDate != null) {
                if (userLocalDb.clientsLastChangeDate.millisecondsSinceEpoch <
                    userFireStoreDb.clientsLastChangeDate
                        .millisecondsSinceEpoch) {
                    await ClientDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncInvoices(Profile userLocalDb, Profile userFireStoreDb) async {

    }

    Future<void> _syncJobs(Profile userLocalDb, Profile userFireStoreDb) async {

    }

    Future<void> _syncLocations(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.locationsLastChangeDate != userFireStoreDb.locationsLastChangeDate) || (userLocalDb.locationsLastChangeDate == null && userFireStoreDb.locationsLastChangeDate != null)) {
            if(userLocalDb.locationsLastChangeDate != null && userFireStoreDb.locationsLastChangeDate != null){
                if(userLocalDb.locationsLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.locationsLastChangeDate.millisecondsSinceEpoch) {
                    await LocationDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncMileageExpenses(Profile userLocalDb, Profile userFireStoreDb) async {

    }

    Future<void> _syncPriceProfiles(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.priceProfilesLastChangeDate != userFireStoreDb.priceProfilesLastChangeDate) || (userLocalDb.priceProfilesLastChangeDate == null && userFireStoreDb.priceProfilesLastChangeDate != null)) {
            if(userLocalDb.priceProfilesLastChangeDate != null && userFireStoreDb.priceProfilesLastChangeDate != null){
                if(userLocalDb.priceProfilesLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.priceProfilesLastChangeDate.millisecondsSinceEpoch) {
                    await PriceProfileDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncRecurringExpenses(Profile userLocalDb, Profile userFireStoreDb) async {

    }

    Future<void> _syncSingleExpenses(Profile userLocalDb, Profile userFireStoreDb) async {

    }
}