import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';

class UserCollection {
  Future<void> createUser(Profile user) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(user.uid)
        .set(user.toMap())
        .catchError((error) => print(error));
  }

  Future<void> deleteUser(String uid) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(uid)
          .delete()
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<DocumentSnapshot> getProfileStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .snapshots();
  }

  Future<Profile?> getUser(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(uid)
        .get()
        .then((userProfile) {
          Profile profile = Profile.fromMap(userProfile.data() as Map<String, dynamic>);
          profile.uid = userProfile.id;
          return profile;
        })
        .catchError((error) => print(error));
  }

  Future<void> updateUser(Profile profile) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(profile.uid)
          .update(profile.toMap())
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }
}