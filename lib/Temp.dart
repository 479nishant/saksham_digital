import 'package:flutter/material.dart';

import 'Courses/Courses.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  int _selectedIndex = 0;

  // Function called when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you would swap out the body content here based on the index
    print('Tab tapped: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- 1. Custom AppBar (Top Bar) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow
        title: const Text(
          'saksham', // Placeholder text for the logo
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
                  Future.delayed(const Duration(seconds: 10), () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.pop(context);
                    }
                  });

                  return Container(
                    width: double.infinity,
                    color: Colors.white, // instead of Colors.blueAccent
                    child: Image.network(
                      "https://img.freepik.com/premium-vector/nothing-here-flat-illustration_418302-77.jpg",
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.notifications, color: Colors.black54), // changed
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),

      // --- 2. Main Body Content (Scrollable) ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

          ),
        ),
      ),

      // --- 3. Bottom Navigation Bar ---

    );
  }
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        // Subtle grey border top border
        border: Border(top: BorderSide(color: lightGrey, width: 1.0)),
      ),
      child: BottomNavigationBar(
        // Use the state variable to highlight the current tab
        currentIndex: _selectedIndex,
        // Use the state function to update the selected index
        onTap: _onItemTapped,

        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Temp()),
                );
              },
              child: const Icon(Icons.school_outlined),
            ),
            // Represents Courses/Learning
            label: 'Courses',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
