import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot snap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      _user = UserModel.fromSnap(snap);
      notifyListeners();
    } catch (e) {
      print("Error refreshing user: $e");
    }
  }
}
