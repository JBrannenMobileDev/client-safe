import 'dart:async';

import 'package:dandylight/data_layer/local_db/daos/ResponseDao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'daos/ClientDao.dart';
import 'daos/ContractDao.dart';
import 'daos/InvoiceDao.dart';
import 'daos/JobDao.dart';
import 'daos/JobReminderDao.dart';
import 'daos/JobTypeDao.dart';
import 'daos/LocationDao.dart';
import 'daos/MileageExpenseDao.dart';
import 'daos/NextInvoiceNumberDao.dart';
import 'daos/PoseDao.dart';
import 'daos/PoseGroupDao.dart';
import 'daos/PriceProfileDao.dart';
import 'daos/ProfileDao.dart';
import 'daos/RecurringExpenseDao.dart';
import 'daos/ReminderDao.dart';
import 'daos/SingleExpenseDao.dart';

class SembastDb {
  // Singleton instance
  static final SembastDb _singleton = SembastDb._();

  // Singleton accessor
  static SembastDb get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database> _dbOpenCompleter;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  SembastDb._();

  // Sembast database object
  Database _database;

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'dandylight.db');

    _database = await databaseFactoryIo.openDatabase(dbPath);
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(_database);
  }

  Future deleteAllLocalData() async {
    await ClientDao.deleteAllLocal();
    await InvoiceDao.deleteAllLocal();
    await JobDao.deleteAllLocal();
    await LocationDao.deleteAllLocal();
    await MileageExpenseDao.deleteAllLocal();
    await PriceProfileDao.deleteAllLocal();
    await RecurringExpenseDao.deleteAllLocal();
    await SingleExpenseDao.deleteAllLocal();
    await NextInvoiceNumberDao.deleteAllLocal();
    await ReminderDao.deleteAllLocal();
    await JobTypeDao.deleteAllLocal();
    await JobReminderDao.deleteAllLocal();
    await ContractDao.deleteAllLocal();
    await PoseDao.deleteAllLocal();
    await PoseGroupDao.deleteAllLocal();
    await ProfileDao.deleteAllProfilesLocal();
    await ResponseDao.deleteAllLocal();
  }
}