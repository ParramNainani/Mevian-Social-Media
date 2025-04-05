// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'add_post_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController _pageController;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.getCurrentUser();

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FeedScreen(),
          SearchScreen(),
          AddPostScreen(),
          ProfileScreen(uid: currentUser?.uid ?? ''),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? Colors.black : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? Colors.black : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? Colors.black : Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 3 ? Colors.black : Colors.grey,
            ),
            label: '',
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
