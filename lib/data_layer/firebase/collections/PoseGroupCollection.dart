import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/PoseGroup.dart';
import 'package:dandylight/utils/UidUtil.dart';

class PoseGroupCollection {
  Future<void> createPoseGroup(PoseGroup group) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('poseGroups')
        .doc(group.documentId)
        .set(group.toMap());
  }

  Future<void> deletePoseGroup(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('poseGroups')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getPoseGroupStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('poseGroups')
        .snapshots();
  }

  Future<PoseGroup> getPoseGroup(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('poseGroups')
        .doc(documentId)
        .get()
        .then((groupSnapshot) {
          PoseGroup result = PoseGroup.fromMap(groupSnapshot.data());
          result.documentId = groupSnapshot.id;
          return result;
        });
  }

  Future<List<PoseGroup>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('poseGroups')
        .get()
        .then((poseGroups) => _buildPoseGroupsList(poseGroups));
  }



  Future<void> updatePoseGroups(PoseGroup poseGroup) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('poseGroups')
          .doc(poseGroup.documentId)
          .update(poseGroup.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<PoseGroup> _buildPoseGroupsList(QuerySnapshot poseGroups) {
    List<PoseGroup> poseGroupsList = [];
    for(DocumentSnapshot groupSnapshot in poseGroups.docs){
      PoseGroup result = PoseGroup.fromMap(groupSnapshot.data());
      result.documentId = groupSnapshot.id;
      poseGroupsList.add(result);
    }
    return poseGroupsList;
  }
}