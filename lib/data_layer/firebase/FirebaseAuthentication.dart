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

  Future<User> registerFirebaseUser(String email, String password, FirebaseAuth auth) async {
    return (await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
      ).user;
  }
}