
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:idp_parking_app/services/userModel.dart';

class AuthService {
  final auth.FirebaseAuth _authInstance = auth.FirebaseAuth.instance;

  UserAccount? _getUserAccountFromFirebase(auth.User? user) {
    if(user == null) {
      return null;
    }
    return UserAccount(user.uid, user.email);
  }

  Stream<UserAccount?>? get user {
    return _authInstance.authStateChanges().map(_getUserAccountFromFirebase);
  }

  Future<UserAccount?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _authInstance.signInWithEmailAndPassword(email: email, password: password);
    return _getUserAccountFromFirebase(credential.user);
  }

  Future<UserAccount?> signUpWithEmailAndPassword(String email, String password) async {
    final credential = await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
    return _getUserAccountFromFirebase(credential.user);
  }

  Future<void> signOutUserAccount() async {
    return await _authInstance.signOut();
  }

  String? get uid {
    final credential = _authInstance.currentUser;
    if (credential==null) {return null;}
    return credential.uid;
  }
}