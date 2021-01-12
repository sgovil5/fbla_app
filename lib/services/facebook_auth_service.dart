import 'package:firebase_auth/firebase_auth.dart';

class FacebookAuthService {
  // Creates an auth token from Firebase Auth's current instance
  final _auth = FirebaseAuth.instance;

  // Gets the current Firebase User every time the user logs in or out
  Stream<FirebaseUser> get currentUser => _auth.onAuthStateChanged;
  // Signs a user with a credential and creates a result for the success of the Authentication
  Future<AuthResult> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
}
