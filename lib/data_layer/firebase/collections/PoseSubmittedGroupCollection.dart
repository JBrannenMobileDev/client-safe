import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/PoseSubmittedGroup.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class PoseSubmittedGroupCollection {
  Future<void> createPoseSubmittedGroup(PoseSubmittedGroup group) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('submittedPoses')
        .doc(group.uid)
        .set(group.toMap());
  }

  Future<void> deletePoseSubmittedGroup(String uid) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('submittedPoses')
          .doc(uid)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<PoseSubmittedGroup>> getPoseSubmittedGroupsThatNeedReview() async {
    final databaseReference = FirebaseFirestore.instance;
    List<PoseSubmittedGroup> resultList = [];
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('submittedPoses')
        .where('needsReview', isEqualTo: true)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        resultList.add(PoseSubmittedGroup.fromMap(docSnapshot.data()));
      }
    });
    return resultList;
  }

  Future<PoseSubmittedGroup> getPoseSubmittedGroupById(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('submittedPoses')
        .doc(uid)
        .get()
        .then((groupSnapshot) {
      PoseSubmittedGroup result = PoseSubmittedGroup.fromMap(groupSnapshot.data() as Map<String, dynamic>);
      return result;
    });
  }

  Future<PoseSubmittedGroup?> getPoseSubmittedGroup() async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('submittedPoses')
        .doc(UidUtil().getUid())
        .get()
        .then((groupSnapshot) {
          if(groupSnapshot.data() == null) return null;
          PoseSubmittedGroup result = PoseSubmittedGroup.fromMap(groupSnapshot.data() as Map<String, dynamic>);
          return result;
        });
  }

  Future<void> updatePoseSubmittedGroups(PoseSubmittedGroup poseGroup) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('submittedPoses')
          .doc(poseGroup.uid)
          .update(poseGroup.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}