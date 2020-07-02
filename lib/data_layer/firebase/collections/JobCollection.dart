import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/UidUtil.dart';

class JobCollection {
  Future<void> createJob(Job job) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .document(job.documentId)
        .setData(job.toMap());
  }

  Future<void> deleteJob(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('jobs')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Job> getJob(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .document(documentId)
        .get()
        .then((jobSnapshot) {
          Job result = Job.fromMap(jobSnapshot.data);
          result.documentId = jobSnapshot.documentID;
          return result;
        });
  }

  Future<List<Job>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .getDocuments()
        .then((jobs) => _buildJobsList(jobs));
  }



  Future<void> updateJob(Job job) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('jobs')
          .document(job.documentId)
          .updateData(job.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Job> _buildJobsList(QuerySnapshot jobs) {
    List<Job> jobsList = List();
    for(DocumentSnapshot jobSnapshot in jobs.documents){
      Job result = Job.fromMap(jobSnapshot.data);
      result.documentId = jobSnapshot.documentID;
      jobsList.add(result);
    }
    return jobsList;
  }
}