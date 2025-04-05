// screens/add_post_screen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final AuthService _authService = AuthService();
  File? _file;
  bool _isLoading = false;

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  void _uploadPost() async {
    if (_file == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        throw 'User not logged in';
      }

      // Get user data
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (!userDoc.exists) {
        throw 'User data not found';
      }

      var userData = userDoc.data() as Map<String, dynamic>;

      // Upload image to firebase storage
      String postId = Uuid().v1();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(postId);

      UploadTask uploadTask = ref.putFile(_file!);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();

      // Create post
      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'postId': postId,
        'uid': currentUser.uid,
        'username': userData['username'],
        'caption': _captionController.text,
        'postUrl': downloadUrl,
        'userPhotoUrl': userData['photoUrl'],
        'datePublished': DateTime.now(),
        'likes': [],
      });

      setState(() {
        _file = null;
        _captionController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          TextButton(
            onPressed: _uploadPost,
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _file == null
                      ? Center(
                        child: IconButton(
                          icon: Icon(Icons.upload),
                          onPressed: _selectImage,
                        ),
                      )
                      : Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_file!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        controller: _captionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
