// models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String photoUrl;
  final List<String> followers;
  final List<String> following;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.photoUrl,
    this.followers = const [],
    this.following = const [],
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'username': username,
    'photoUrl': photoUrl,
    'followers': followers,
    'following': following,
  };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      followers: List<String>.from(snapshot['followers'] ?? []),
      following: List<String>.from(snapshot['following'] ?? []),
    );
  }
}
