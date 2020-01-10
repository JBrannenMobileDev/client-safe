import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class JobDao extends Equatable{
  static const String JOB_STORE_NAME = 'jobs';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  final _jobStore = intMapStoreFactory.store(JOB_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SembastDb.instance.database;

  Future insert(Job job) async {
    await _jobStore.add(await _db, job.toMap());
  }

  Future insertOrUpdate(Job job) async {
    List<Job> jobList = await getAllSortedByTitle();
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

  Future update(Job job) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(job.id));
    await _jobStore.update(
      await _db,
      job.toMap(),
      finder: finder,
    );
  }

  Future delete(Job job) async {
    final finder = Finder(filter: Filter.byKey(job.id));
    await _jobStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Job>> getAllSortedByTitle() async {
    final finder = Finder(sortOrders: [
      SortOrder('jobTitle'),
    ]);

    final recordSnapshots = await _jobStore.find(await _db, finder: finder);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList();
  }

  Future<List<Job>> getAllUpcomingJobs() async {
    final finder = Finder(sortOrders: [
      SortOrder('jobTitle'),
    ]);

    final recordSnapshots = await _jobStore.find(await _db, finder: finder);

    // Making a List<Job> out of List<RecordSnapshot>
    List<Job> jobList = recordSnapshots.map((snapshot) {
      final job = Job.fromMap(snapshot.value);
      job.id = snapshot.key;
      return job;
    }).toList();
    return jobList.where((job) => (job.dateTime.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch)).toList();
  }
}