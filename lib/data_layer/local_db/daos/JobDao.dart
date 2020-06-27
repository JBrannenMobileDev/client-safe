import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/JobCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class JobDao extends Equatable{
  static void insert(Job job) {
    JobCollection().createJob(job);
  }

  static Future insertOrUpdate(Job job) async {
    bool alreadyExists = job.documentId.isNotEmpty;

    if(alreadyExists){
      update(job);
    }else{
      insert(job);
    }
  }

  static void update(Job job) {
    JobCollection().updateJob(job);
  }

  static void delete(Job job) {
    JobCollection().deleteJob(job.documentId);
  }

   static Future<List<Job>> getAllJobs() async {
    return await JobCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static Future<Job> getJobById(String jobDocumentId) async{
    return await JobCollection().getJob(jobDocumentId);
  }
}