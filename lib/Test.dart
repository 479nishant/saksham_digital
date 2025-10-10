import 'package:flutter/material.dart';
import 'package:saksham_digital/Ceritificates/CertificateReq.dart';
import 'package:saksham_digital/Courses/Courses.dart';
import 'package:saksham_digital/InternshipPage/InternshipPage.dart';
import 'package:saksham_digital/Tutorial/Tutorial.dart';
import 'User/UserInfo.dart'; // Update profile page

const Color primaryRed = Color(0xFFE91E63);
const Color lightGrey = Color(0xFFF0F0F0);

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int _selectedIndex = 0;

  // Define pages for BottomNavigationBar
  final List<Widget> _pages = [
    const TestContentPage(),    // Home tab
    const CoursePage(),         // Courses tab
    const UpdateUserInfoPage(), // Profile tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'saksham',
          style: TextStyle(
            color: primaryRed,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                enableDrag: false,
                showDragHandle: true,
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(seconds: 6), () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    }
                  });
                  return Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Image.network(
                      "https://img.freepik.com/premium-vector/nothing-here-flat-illustration_418302-77.jpg",
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.notifications, color: Colors.black54),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Show page based on tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ------------------- Home Content -------------------

class TestContentPage extends StatelessWidget {
  const TestContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryGrid(context),
          const SizedBox(height: 24),
          Text(
            'Featured Content',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeaturedContentGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Courses',
        'icon': Icons.book_outlined,
        'page': const CoursePage(),
      },
      {
        'title': 'Tutorials',
        'icon': Icons.play_circle_outline,
        'page': const TutorialsPage(),
      },
      {
        'title': 'Certificates',
        'icon': Icons.workspace_premium_outlined,
        'page': const Certificatereq(),
      },
      {
        'title': 'Internships',
        'icon': Icons.work_outline,
        'page': const InternshipPage(),
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.5,
      children: categories.map((item) => _buildCategoryCard(
        context,
        item['title'] as String,
        item['icon'] as IconData,
        item['page'] as Widget,
      )).toList(),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: primaryRed),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContentGrid() {
    final List<Map<String, dynamic>> featuredItems = [
      {'title': 'New Course\nAI Ethics', 'icon': Icons.laptop_chromebook_outlined},
      {'title': 'Tutorial:\nMaster Flutter', 'icon': Icons.bookmark_border_outlined},
      {'title': 'Certification:\nCyber Security', 'icon': Icons.security_outlined},
      {'title': 'Internship:\nWeb Dev', 'icon': Icons.handshake_outlined},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.0,
      children: featuredItems.map((item) => _buildFeaturedCard(
        item['title'] as String,
        item['icon'] as IconData,
      )).toList(),
    );
  }

  Widget _buildFeaturedCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 30, color: primaryRed),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
