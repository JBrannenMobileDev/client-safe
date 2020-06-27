import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/UidUtil.dart';

class JobCollection {
  Future<void> createJob(Job job) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .add(job.toMap());
  }

  void deleteJob(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
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
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .document(documentId)
        .get()
        .then((snapshot) => Job.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<Job>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobs')
        .getDocuments()
        .then((jobs) => _buildJobsList(jobs));
  }



  void updateJob(Job job) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
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
      jobsList.add(Job.fromMap(jobSnapshot.data, jobSnapshot.documentID));
    }
    return jobsList;
  }
}