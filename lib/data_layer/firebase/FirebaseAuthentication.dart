import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseDao.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  Future<User> handleSignIn(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return (await _auth.signInWithEmailAndPassword(email: null, password: null)).user;
  }

  Future<void> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }
  
  Future<void> deleteAccount() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.currentUser.delete();
  }

  Future<User> registerFirebaseUser(String email, String password, FirebaseAuth auth) async {
    return (await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
      ).user;
  }

  Future deleteFirebaseData() async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference.collection('suggestions').doc(UidUtil().getUid()).delete();
    await LocationDao.deleteAllRemote();
    await PoseDao.deleteAllRemote();
    await InvoiceDao.deleteAllRemote();
    await ContractDao.deleteAllRemote();
    await databaseReference.collection('users').doc(UidUtil().getUid()).delete();
  }
}