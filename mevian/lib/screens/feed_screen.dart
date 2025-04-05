import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart' as model;
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Placeholder posts for demonstration
  final List<Map<String, dynamic>> _placeholderPosts = [
    {
      'username': 'user1',
      'uid': '1',
      'photoUrl': 'https://picsum.photos/id/101/300/300',
      'postId': '1',
      'postUrl': 'https://picsum.photos/id/1/500/500',
      'caption': 'Beautiful day!',
      'likes': ['2', '3'],
      'datePublished': DateTime.now(),
      'comments': [
        {'username': 'user2', 'text': 'Looks amazing!'},
        {'username': 'user3', 'text': 'Great photo!'},
      ],
    },
    {
      'username': 'user2',
      'uid': '2',
      'photoUrl': 'https://picsum.photos/id/101/300/300',
      'postId': '2',
      'postUrl': 'https://picsum.photos/id/10/500/500',
      'caption': 'Enjoying the weekend',
      'likes': ['1'],
      'datePublished': DateTime.now().subtract(const Duration(days: 1)),
      'comments': [
        {'username': 'user1', 'text': 'Having fun?'},
        {'username': 'user3', 'text': 'Wish I was there!'},
      ],
    },
    {
      'username': 'user3',
      'uid': '3',
      'photoUrl': 'https://picsum.photos/id/101/300/300',
      'postId': '3',
      'postUrl': 'https://picsum.photos/id/20/500/500',
      'caption': 'New adventure',
      'likes': [],
      'datePublished': DateTime.now().subtract(const Duration(days: 2)),
      'comments': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final model.UserModel? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar:
          width > webScreenSize
              ? null
              : AppBar(
                backgroundColor: mobileBackgroundColor,
                centerTitle: false,
                title: Image.network(
                  'https://picsum.photos/200/300',
                  color: primaryColor,
                  height: 32,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.messenger_outline,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Use placeholder posts if no data or error
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return ListView.builder(
              itemCount: _placeholderPosts.length,
              itemBuilder:
                  (ctx, index) => PostCard(
                    snap: _placeholderPosts[index],
                    isPlaceholder: true,
                  ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder:
                (ctx, index) =>
                    PostCard(snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
    );
  }
}
