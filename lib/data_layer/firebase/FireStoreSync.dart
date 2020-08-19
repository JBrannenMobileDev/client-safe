import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/models/SingleExpense.dart';
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
                await _syncNextInvoiceNumber(userLocalDb, userFireStoreDb);
                await _syncProfile(userLocalDb, userFireStoreDb);
                await _syncReminders(userLocalDb, userFireStoreDb);
            }
        }
        setupFireStoreListeners();
    }

    Future<void> setupFireStoreListeners () async {
        NextInvoiceNumberDao.getStreamFromFireStore()
            .listen((documentSnapshot) async {
                NextInvoiceNumber nextNumber = NextInvoiceNumber.fromMap(documentSnapshot.data);
                NextInvoiceNumber nextNumberLocal = await NextInvoiceNumberDao.getNextNumber();
                nextNumber.id = 1;
                if(nextNumberLocal != null) {
                    NextInvoiceNumberDao.updateLocalOnly(nextNumber);
                }else {
                    NextInvoiceNumberDao.insertLocalOnly(nextNumber);
                }
        });

        ClientDao.getClientsStreamFromFireStore()
            .listen((snapshots) async {
                for(DocumentChange snapshot in snapshots.documentChanges) {
                    Client client = Client.fromMap(snapshot.document.data);
                    Client clientFromLocal = await ClientDao.getClientById(client.documentId);
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
                PriceProfile priceProfileFromLocal = await PriceProfileDao.getById(priceProfile.documentId);
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
                Location locationFromLocal = await LocationDao.getById(location.documentId);
                if(locationFromLocal != null) {
                    LocationDao.updateLocalOnly(location);
                }else {
                    LocationDao.insertLocalOnly(location);
                }
            }
        });

        JobDao.getJobsStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                Job job = Job.fromMap(snapshot.document.data);
                Job jobFromLocal = await JobDao.getJobById(job.documentId);
                if(jobFromLocal != null) {
                    JobDao.updateLocalOnly(job);
                }else {
                    JobDao.insertLocalOnly(job);
                }
            }
        });

        InvoiceDao.getInvoicesStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                Invoice invoice = Invoice.fromMap(snapshot.document.data);
                Invoice invoiceFromLocal = await InvoiceDao.getInvoiceById(invoice.documentId);
                if(invoiceFromLocal != null) {
                    InvoiceDao.updateLocalOnly(invoice);
                }else {
                    InvoiceDao.insertLocalOnly(invoice);
                }
            }
        });

        MileageExpenseDao.getMileageExpensesStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                MileageExpense expense = MileageExpense.fromMap(snapshot.document.data);
                MileageExpense expenseFromLocal = await MileageExpenseDao.getMileageExpenseById(expense.documentId);
                if(expenseFromLocal != null) {
                    MileageExpenseDao.updateLocalOnly(expense);
                }else {
                    MileageExpenseDao.insertLocalOnly(expense);
                }
            }
        });

        RecurringExpenseDao.getRecurringExpensesStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                RecurringExpense expense = RecurringExpense.fromMap(snapshot.document.data);
                RecurringExpense expenseFromLocal = await RecurringExpenseDao.getRecurringExpenseById(expense.documentId);
                if(expenseFromLocal != null) {
                    RecurringExpenseDao.updateLocalOnly(expense);
                }else {
                    RecurringExpenseDao.insertLocalOnly(expense);
                }
            }
        });

        SingleExpenseDao.getSingleExpensesStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                SingleExpense expense = SingleExpense.fromMap(snapshot.document.data);
                SingleExpense expenseFromLocal = await SingleExpenseDao.getSingleExpenseById(expense.documentId);
                if(expenseFromLocal != null) {
                    SingleExpenseDao.updateLocalOnly(expense);
                }else {
                    SingleExpenseDao.insertLocalOnly(expense);
                }
            }
        });

        ReminderDao.getReminderStreamFromFireStore()
            .listen((snapshots) async {
            for(DocumentChange snapshot in snapshots.documentChanges) {
                Reminder reminder = Reminder.fromMap(snapshot.document.data);
                Reminder reminderFromLocal = await ReminderDao.getReminderById(reminder.documentId);
                if(reminderFromLocal != null) {
                    ReminderDao.updateLocalOnly(reminder);
                }else {
                    ReminderDao.insertLocalOnly(reminder);
                }
            }
        });

        ProfileDao.getProfileStreamFromFireStore()
            .listen((snapshot) async {
                Profile profile = Profile.fromMap(snapshot.data);
                Profile profileFromLocal = (await ProfileDao.getAll()).elementAt(0);
                if(profileFromLocal != null) {
                    ProfileDao.updateLocalOnly(profile);
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
        if((userLocalDb.invoicesLastChangeDate != userFireStoreDb.invoicesLastChangeDate) || (userLocalDb.invoicesLastChangeDate == null && userFireStoreDb.invoicesLastChangeDate != null)) {
            if(userLocalDb.invoicesLastChangeDate != null && userFireStoreDb.invoicesLastChangeDate != null){
                if(userLocalDb.invoicesLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.invoicesLastChangeDate.millisecondsSinceEpoch) {
                    await InvoiceDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncJobs(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.jobsLastChangeDate != userFireStoreDb.jobsLastChangeDate) || (userLocalDb.jobsLastChangeDate == null && userFireStoreDb.jobsLastChangeDate != null)) {
            if(userLocalDb.jobsLastChangeDate != null && userFireStoreDb.jobsLastChangeDate != null){
                if(userLocalDb.jobsLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.jobsLastChangeDate.millisecondsSinceEpoch) {
                    await JobDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
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
        if((userLocalDb.mileageExpensesLastChangeDate != userFireStoreDb.mileageExpensesLastChangeDate) || (userLocalDb.mileageExpensesLastChangeDate == null && userFireStoreDb.mileageExpensesLastChangeDate != null)) {
            if(userLocalDb.mileageExpensesLastChangeDate != null && userFireStoreDb.mileageExpensesLastChangeDate != null){
                if(userLocalDb.mileageExpensesLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.mileageExpensesLastChangeDate.millisecondsSinceEpoch) {
                    await MileageExpenseDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
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
        if((userLocalDb.recurringExpensesLastChangeDate != userFireStoreDb.recurringExpensesLastChangeDate) || (userLocalDb.recurringExpensesLastChangeDate == null && userFireStoreDb.recurringExpensesLastChangeDate != null)) {
            if(userLocalDb.recurringExpensesLastChangeDate != null && userFireStoreDb.recurringExpensesLastChangeDate != null){
                if(userLocalDb.recurringExpensesLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.recurringExpensesLastChangeDate.millisecondsSinceEpoch) {
                    await RecurringExpenseDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncNextInvoiceNumber(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.nextInvoiceNumberLastChangeDate != userFireStoreDb.nextInvoiceNumberLastChangeDate) || (userLocalDb.nextInvoiceNumberLastChangeDate == null && userFireStoreDb.nextInvoiceNumberLastChangeDate != null)) {
            if(userLocalDb.nextInvoiceNumberLastChangeDate != null && userFireStoreDb.nextInvoiceNumberLastChangeDate != null){
                if(userLocalDb.nextInvoiceNumberLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.nextInvoiceNumberLastChangeDate.millisecondsSinceEpoch) {
                    await NextInvoiceNumberDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncSingleExpenses(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.singleExpensesLastChangeDate != userFireStoreDb.singleExpensesLastChangeDate) || (userLocalDb.singleExpensesLastChangeDate == null && userFireStoreDb.singleExpensesLastChangeDate != null)) {
            if(userLocalDb.singleExpensesLastChangeDate != null && userFireStoreDb.singleExpensesLastChangeDate != null){
                if(userLocalDb.singleExpensesLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.singleExpensesLastChangeDate.millisecondsSinceEpoch) {
                    await SingleExpenseDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncReminders(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.remindersLastChangeDate != userFireStoreDb.remindersLastChangeDate) || (userLocalDb.remindersLastChangeDate == null && userFireStoreDb.remindersLastChangeDate != null)) {
            if(userLocalDb.remindersLastChangeDate != null && userFireStoreDb.remindersLastChangeDate != null){
                if(userLocalDb.remindersLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.remindersLastChangeDate.millisecondsSinceEpoch) {
                    await ReminderDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }

    Future<void> _syncProfile(Profile userLocalDb, Profile userFireStoreDb) async {
        if((userLocalDb.profileLastChangeDate != userFireStoreDb.profileLastChangeDate) || (userLocalDb.profileLastChangeDate == null && userFireStoreDb.profileLastChangeDate != null)) {
            if(userLocalDb.profileLastChangeDate != null && userFireStoreDb.profileLastChangeDate != null){
                if(userLocalDb.profileLastChangeDate.millisecondsSinceEpoch < userFireStoreDb.profileLastChangeDate.millisecondsSinceEpoch) {
                    await ProfileDao.syncAllFromFireStore();
                } else {
                    //do nothing localFirebase cache has not synced up to cloud yet.
                }
            }
        }
    }
}