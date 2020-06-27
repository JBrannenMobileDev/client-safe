import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Profile.dart';

class UserCollection {
  Future<void> createUser(Profile user) async {
    final databaseReference = Firestore.instance;
    await databaseReference.collection('users')
        .document(user.uid)
        .setData(user.toMap());
  }

  void deleteUser(String uid) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(uid)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Profile> getUser(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(uid)
        .get()
        .then((userProfile) => Profile.fromMap(userProfile.data, userProfile.documentID));
  }

  void updateUser(Profile profile) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(profile.uid)
          .updateData(profile.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}