import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';

class PoseLibraryGroupsCollection {
  Future<void> create(PoseLibraryGroup group) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('poseLibraryGroups')
        .doc(group.documentId)
        .set(group.toMap())
        .catchError((error) => print(error));
  }

  Future<void> delete(String documentId) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('poseLibraryGroups')
          .doc(documentId)
          .delete()
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<PoseLibraryGroup>> get() async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('poseLibraryGroups')
        .get()
        .then((groups) => _buildList(groups));

  }

  List<PoseLibraryGroup> _buildList(QuerySnapshot jobs) {
    List<PoseLibraryGroup> list = [];
    for(DocumentSnapshot jobSnapshot in jobs.docs){
      PoseLibraryGroup result = PoseLibraryGroup.fromMap(jobSnapshot.data() as Map<String, dynamic>);
      result.documentId = jobSnapshot.id;
      list.add(result);
    }
    return list;
  }

  Future<void> update(PoseLibraryGroup libraryGroup) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('poseLibraryGroups')
          .doc(libraryGroup.documentId)
          .update(libraryGroup.toMap())
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }
}