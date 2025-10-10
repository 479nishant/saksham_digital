import 'package:flutter/material.dart';
import 'InternshipPage/InternshipPage.dart'; // Make sure this page exists

// --- COLOR PALETTE DEFINITIONS (Consistent with Login Page) ---
const Color primaryRed = Color(0xFFC72F3A); // Deep Red from the design
const Color lightRedContainer = Color(0xFFFFEBEE); // A very light, subtle red for the background of the card

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Welcome text ---
          Text(
            "Welcome to Saksham!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // Use the primary brand red
              color: primaryRed,
            ),
          ),
          const SizedBox(height: 24),

          // --- Internship section container (Call-to-Action Card) ---
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InternshipPage(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Use a very light red background
                color: lightRedContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryRed.withOpacity(0.2), // Reddish shadow
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon added for visual interest
                  const Icon(
                    Icons.work_outline,
                    color: primaryRed,
                    size: 30,
                  ),
                  const SizedBox(width: 15),

                  // Text
                  Expanded(
                    child: Text(
                      "Explore Internship Opportunities",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // Use a slightly darker red text
                        color: primaryRed,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Arrow icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: primaryRed,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}