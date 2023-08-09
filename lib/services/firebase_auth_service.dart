import 'package:friend_circle/models/user_model.dart';
import 'package:friend_circle/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  UserModel? userFromFirebase(User? user) {
    //debugPrint("auth user: ${user?.email}");
    return UserModel(userID: user?.uid, email: user?.email);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    User? user = await firebaseAuth.currentUser;

    return userFromFirebase(user);
  }

  @override
  Future<bool> logOut() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      await firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("Firebase_auth_service sign out error: $e");
      return false;
    }
  }

  @override
  Future<UserModel?> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        UserCredential result = await firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));
        User? user = result.user;
        return userFromFirebase(user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> register(String? email, String? password) async {

    try {
      UserCredential? result = await firebaseAuth.createUserWithEmailAndPassword(email: email!, password: password!);
      return userFromFirebase(result.user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> login(String? email, String? password) async {
    try {
      UserCredential? result = await firebaseAuth.signInWithEmailAndPassword(email: email!, password: password!);
      return userFromFirebase(result.user);
    } catch (e) {
      return null;
    }
  }
}
