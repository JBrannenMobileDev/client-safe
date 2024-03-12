import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/EnvironmentUtil.dart';

class FirebaseAuthentication {
  Future<User?> handleSignIn(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<void> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  Future<bool> reAuthenticateUser(String password, String email) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      User? user = _auth.currentUser;
      AuthCredential credentials = EmailAuthProvider.credential(email: email, password: password);
      await user?.reauthenticateWithCredential(credentials);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
  
  void deleteAccount(String password, String email) async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  Future<User?> registerFirebaseUser(String email, String password, FirebaseAuth auth) async {
    return (await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
      ).user;
  }

  Future deleteFirebaseData() async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference.collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users').doc(UidUtil().getUid()).delete();
  }
}