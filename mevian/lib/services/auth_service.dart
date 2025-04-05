import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        username: '',
        photoUrl: '',
      );
    }
    return null;
  }

  // Sign up user
  Future<UserModel> signupUser({
    required String email,
    required String password,
    required String username,
    String? photoUrl,
  }) async {
    try {
      // Register user with email and password
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model
      UserModel user = UserModel(
        uid: cred.user!.uid,
        email: email,
        username: username,
        photoUrl: photoUrl ?? '',
      );

      // Add user to firestore
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  // Login user
  Future<UserModel> loginUser(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(cred.user!.uid).get();

      return UserModel.fromSnap(userDoc);
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
