// models/post_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String uid;
  final String username;
  final String caption;
  final String postUrl;
  final String userPhotoUrl;
  final DateTime datePublished;
  final List<String> likes;

  PostModel({
    required this.postId,
    required this.uid,
    required this.username,
    required this.caption,
    required this.postUrl,
    required this.userPhotoUrl,
    required this.datePublished,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'uid': uid,
    'username': username,
    'caption': caption,
    'postUrl': postUrl,
    'userPhotoUrl': userPhotoUrl,
    'datePublished': datePublished,
    'likes': likes,
  };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      caption: snapshot['caption'],
      postUrl: snapshot['postUrl'],
      userPhotoUrl: snapshot['userPhotoUrl'],
      datePublished:
          snapshot['datePublished'] is Timestamp
              ? (snapshot['datePublished'] as Timestamp).toDate()
              : snapshot['datePublished'],
      likes: List<String>.from(snapshot['likes'] ?? []),
    );
  }
}
