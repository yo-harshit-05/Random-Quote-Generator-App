import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {

    UserCredential credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);

    await credential.user?.reload();

    return _auth.currentUser;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {

    UserCredential credential =
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }
}