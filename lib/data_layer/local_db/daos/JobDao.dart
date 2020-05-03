import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Job.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class JobDao extends Equatable{
  static const String JOB_STORE_NAME = 'jobs';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _jobStore = intMapStoreFactory.store(JOB_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Job job) async {
    await _jobStore.add(await _db, job.toMap());
  }

  static Future insertOrUpdate(Job job) async {
    List<Job> jobList = await getAllJobs();
    bool alreadyExists = false;
    for(Job singleJob in jobList){
      if(singleJob.id == job.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(job);
    }else{
      await insert(job);
    }
  }

  static Future update(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(job.id));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
  }

  static Future delete(Job job) async {
    final finder = Finder(filter: Filter.byKey(job.id));
    await _jobStore.delete(
      await _db,
      finder: finder,
    );
  }

   static Future<List<Job>> getAllJobs() async {
    final recordSnapshots = await _jobStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static Future<Job> getJobById(int jobId) async{
    final finder = Finder(filter: Filter.equals('id', jobId));
    final recordSnapshots = await _jobStore.find(await _db, finder: finder);
    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList().elementAt(0);
  }
}