import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/UidUtil.dart';

class JobCollection {
  Future<void> createJob(Job job) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobs')
        .doc(job.documentId)
        .set(job.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobs')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getJobsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobs')
        .snapshots();
  }

  Future<Job> getJob(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobs')
        .doc(documentId)
        .get()
        .then((jobSnapshot) {
          Job result = Job.fromMap(jobSnapshot.data());
          result.documentId = jobSnapshot.id;
          return result;
        });
  }

  Future<List<Job>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobs')
        .get()
        .then((jobs) => _buildJobsList(jobs));
  }



  Future<void> updateJob(Job job) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobs')
          .doc(job.documentId)
          .update(job.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Job> _buildJobsList(QuerySnapshot jobs) {
    List<Job> jobsList = List();
    for(DocumentSnapshot jobSnapshot in jobs.docs){
      Job result = Job.fromMap(jobSnapshot.data());
      result.documentId = jobSnapshot.id;
      jobsList.add(result);
    }
    return jobsList;
  }
}