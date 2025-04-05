import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  // Placeholder users for demonstration
  final List<Map<String, dynamic>> _placeholderUsers = [
    {
      'username': 'john_doe',
      'photoUrl': 'https://picsum.photos/id/237/200/300',
      'uid': '1',
      'bio': 'Photography enthusiast',
    },
    {
      'username': 'jane_smith',
      'photoUrl': 'https://picsum.photos/seed/picsum/200/300',
      'uid': '2',
      'bio': 'Travel lover',
    },
    {
      'username': 'alex_wilson',
      'photoUrl': 'https://picsum.photos/200/300?grayscale',
      'uid': '3',
      'bio': 'Food blogger',
    },
  ];

  // Placeholder posts for demonstration
  final List<String> _placeholderPosts = [
    'https://picsum.photos/id/1/300/300',
    'https://picsum.photos/id/10/300/300',
    'https://picsum.photos/id/20/300/300',
    'https://picsum.photos/id/30/300/300',
    'https://picsum.photos/id/40/300/300',
    'https://picsum.photos/id/50/300/300',
    'https://picsum.photos/id/60/300/300',
    'https://picsum.photos/id/70/300/300',
    'https://picsum.photos/id/80/300/300',
  ];

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for a user...',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body:
          isShowUsers
              ? FutureBuilder(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .where(
                          'username',
                          isGreaterThanOrEqualTo: searchController.text,
                        )
                        .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      itemCount: _placeholderUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              _placeholderUsers[index]['photoUrl'],
                            ),
                            radius: 16,
                          ),
                          title: Text(_placeholderUsers[index]['username']),
                        );
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      );
                    },
                  );
                },
              )
              : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return GridView.builder(
                      itemCount: _placeholderPosts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 1.5,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        return Image.network(
                          _placeholderPosts[index],
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  }

                  return GridView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      String postUrl =
                          (snapshot.data! as dynamic).docs[index]['postUrl'];
                      return Image.network(postUrl, fit: BoxFit.cover);
                    },
                  );
                },
              ),
    );
  }
}
