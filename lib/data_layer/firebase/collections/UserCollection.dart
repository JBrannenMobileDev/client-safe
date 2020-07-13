import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';

class UserCollection {
  Future<void> createUser(Profile user) async {
    final databaseReference = Firestore.instance;
    await databaseReference.collection('users')
        .document(user.uid)
        .setData(user.toMap())
        .catchError((error) => print(error));
  }

  Future<void> deleteUser(String uid) async{
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(uid)
          .delete()
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<DocumentSnapshot> getProfileStream() {
    return Firestore.instance
        .collection('users')
        .document(UidUtil().getUid())
        .snapshots();
  }

  Future<Profile> getUser(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(uid)
        .get()
        .then((userProfile) {
          Profile profile = Profile.fromMap(userProfile.data);
          profile.uid = userProfile.documentID;
          return profile;
        })
        .catchError((error) => print(error));
  }

  Future<void> updateUser(Profile profile) async{
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(profile.uid)
          .updateData(profile.toMap())
          .catchError((error) => print(error));
    } catch (e) {
      print(e.toString());
    }
  }
}