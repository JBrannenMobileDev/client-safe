import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class JobTypesCollection {
  Future<void> createJobType(JobType jobType) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobTypes')
        .doc(jobType.documentId)
        .set(jobType.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteJobType(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobTypes')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getJobTypesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobTypes')
        .snapshots();
  }

  Future<JobType> getJobType(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobTypes')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          JobType jobType = JobType.fromMap(expenseSnapshot.data());
          jobType.documentId = expenseSnapshot.id;
          return jobType;
        });
  }

  Future<List<JobType>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobTypes')
        .get()
        .then((jobTypes) => _buildJobTypesList(jobTypes));
  }



  Future<void> updateJobType(JobType jobType) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobTypes')
          .doc(jobType.documentId)
          .update(jobType.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<JobType> _buildJobTypesList(QuerySnapshot jobTypes) {
    List<JobType> jobTypesList = [];
    for(DocumentSnapshot jobTypesSnapshot in jobTypes.docs){
      JobType jobType = JobType.fromMap(jobTypesSnapshot.data());
      jobType.documentId = jobTypesSnapshot.id;
      jobTypesList.add(jobType);
    }
    return jobTypesList;
  }
}