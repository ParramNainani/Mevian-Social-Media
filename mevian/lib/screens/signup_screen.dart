// screens/signup_screen.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final AuthService _authService = AuthService();
  File? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String photoUrl = '';

      // Upload profile image if selected
      if (_image != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profilePics')
            .child(_usernameController.text);

        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot snap = await uploadTask;
        photoUrl = await snap.ref.getDownloadURL();
      }

      // Sign up user
      await _authService.signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        photoUrl: photoUrl,
      );

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              // Logo
              Text(
                'Mevian',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Billabong',
                ),
              ),
              SizedBox(height: 32),
              // Profile pic
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(_image!),
                      )
                      : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://i.stack.imgur.com/l60Hf.png',
                        ),
                      ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: _selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Username
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              // Bio
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  hintText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Sign up button
              InkWell(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.blue,
                  ),
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 12),
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Already have an account?"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        " Log in.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
