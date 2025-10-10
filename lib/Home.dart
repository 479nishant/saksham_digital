import 'package:flutter/material.dart';
import 'package:saksham_digital/Test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Courses/Courses.dart'; // CoursePage
import 'Tutorial/Tutorial.dart'; // TutorialsPage
import 'User/UserInfo.dart'; // UpdateUserInfoPage

// --- COLOR PALETTE ---
const Color primaryRed = Color(0xFFC72F3A);
const Color lightGrayBackground = Color(0xFFF5F5F5);
const Color darkText = Color(0xFF333333);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _saveSession();
  }

  Future<void> _saveSession() async {
    final mprefs = await SharedPreferences.getInstance();
    await mprefs.setBool('isLoggedIn', true);
  }

  int _selectedIndex = 0;

  // Pages for 3 tabs
  final List<Widget> _pages = [
    const Test(),           // Home / Dashboard
    const CoursePage(),     // Courses
    const TutorialsPage(),  // Tutorials
  ];

  final List<BottomNavigationBarItem> _bottomItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.school), label: "Courses"),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Tutorial"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrayBackground,
      appBar: AppBar(
        title: Text(
          _bottomItems[_selectedIndex].label!,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryRed,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateUserInfoPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: primaryRed.withOpacity(0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onItemTapped,
      ),
    );
  }
}
