import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../models/user_model.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  final Map<String, dynamic> _placeholderUserData = {
    'username': 'user_profile',
    'photoUrl': 'https://picsum.photos/200',
    'uid': '123',
    'bio': 'This is a placeholder bio',
    'followers': ['1', '2'],
    'following': ['3', '4'],
  };

  final List<String> _placeholderPosts = [
    'https://picsum.photos/id/100/300/300',
    'https://picsum.photos/id/101/300/300',
    'https://picsum.photos/id/102/300/300',
    'https://picsum.photos/id/103/300/300',
    'https://picsum.photos/id/104/300/300',
    'https://picsum.photos/id/105/300/300',
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .get();

      var postSnap =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: widget.uid)
              .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers'].contains(
        FirebaseAuth.instance.currentUser!.uid,
      );
    } catch (e) {
      userData = _placeholderUserData;
      postLen = _placeholderPosts.length;
      followers = _placeholderUserData['followers'].length;
      following = _placeholderUserData['following'].length;
      isFollowing = false;
    }
    setState(() {
      isLoading = false;
    });
  }

  void _toggleFollow() {
    setState(() {
      if (isFollowing) {
        followers--;
      } else {
        followers++;
      }
      isFollowing = !isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.UserModel? user = Provider.of<UserProvider>(context).getUser;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Text(userData['username'] ?? 'Username'),
            centerTitle: false,
          ),
          body: ListView(
            children: [
              const SizedBox(height: 10),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'] ?? 'https://picsum.photos/200',
                          ),
                          radius: 40,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatColumn(postLen, "posts"),
                                  buildStatColumn(followers, "followers"),
                                  buildStatColumn(following, "following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? Column(
                                        children: [
                                          FollowButton(
                                            text: 'Edit Profile',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () {},
                                          ),
                                          const SizedBox(height: 6),
                                          FollowButton(
                                            text: 'Logout',
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            borderColor: Colors.red,
                                            function: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();

                                              if (context.mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Successfully logged out!',
                                                      style: TextStyle(
                                                        color: Colors.yellow,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.black87,
                                                    duration: Duration(
                                                      seconds: 2,
                                                    ),
                                                  ),
                                                );

                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );

                                                Navigator.of(
                                                  context,
                                                ).pushReplacementNamed(
                                                  '/login',
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                      : isFollowing
                                      ? FollowButton(
                                        text: 'Unfollow',
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        borderColor: Colors.grey,
                                        function: _toggleFollow,
                                      )
                                      : FollowButton(
                                        text: 'Follow',
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        borderColor: Colors.blue,
                                        function: _toggleFollow,
                                      ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        userData['username'] ?? 'Username',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(userData['bio'] ?? 'Bio'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                future:
                    FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      (snapshot.data! as dynamic).docs.isEmpty) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data! as dynamic).docs[index];

                      return Image.network(snap['postUrl'], fit: BoxFit.cover);
                    },
                  );
                },
              ),
            ],
          ),
        );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;

  const FollowButton({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textColor,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 250,
          height: 27,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
