import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Ensure previous sessions are cleared
      await googleSignIn.signOut();

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      // Sign in and get user data
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      // If new user, add to Firestore
      if (result.additionalUserInfo!.isNewUser) {
        addUserToFirestore(
            result.user!.uid, result.user!.email, result.user!.photoURL);
      }
    } catch (e) {
      throw Exception('signInWithGoogle() error: $e');
    }
  }

// Create a new account
  Future<void> signUpWithEmailPassword(email, pass) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // save the new user to firestore
      addUserToFirestore(
          result.user!.uid, result.user!.email, result.user!.photoURL);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('signUp() error: $e');
    }
  }

// Sign in with existing account
  Future<void> signInWithEmailPassword(email, pass) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> addUserToFirestore(
      String userID, String? userEmail, String? avatarUrl) async {
    final user = <String, dynamic>{
      'uid': userID,
      'email': userEmail,
      'avatarUrl': avatarUrl,
    };

    await _db.collection("users").doc(userID).set(user).onError(
          (e, _) => throw Exception("Error saving user to Firestore: $e"),
        );
  }
}
