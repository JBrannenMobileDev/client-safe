import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/Pose.dart';
import '../../../utils/EnvironmentUtil.dart';

class LibraryPoseCollection {
  Future<void> createPose(Pose pose) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('libraryPoses')
        .doc(pose.documentId)
        .set(pose.toMap());
  }

  Future<void> deletePose(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('libraryPoses')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getPosesStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('libraryPoses')
        .snapshots();
  }

  Future<Pose> getPose(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('libraryPoses')
        .doc(documentId)
        .get()
        .then((posesSnapshot) {
          Pose result = Pose.fromMap(posesSnapshot.data() as Map<String, dynamic>);
          result.documentId = posesSnapshot.id;
          return result;
        });
  }

  Future<List<Pose>> getAll() async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('libraryPoses')
        .get()
        .then((poses) => _buildPosesList(poses));
  }



  Future<void> updatePose(Pose pose) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('libraryPoses')
          .doc(pose.documentId)
          .update(pose.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Pose> _buildPosesList(QuerySnapshot poses) {
    List<Pose> posesList = [];
    for(DocumentSnapshot poseSnapshot in poses.docs){
      Pose result = Pose.fromMap(poseSnapshot.data() as Map<String, dynamic>);
      result.documentId = poseSnapshot.id;
      posesList.add(result);
    }
    return posesList;
  }
}