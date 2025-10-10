import 'package:flutter/material.dart';

import '../MODELS/TutorialsResponse.dart';
 // Import your model

// --- COLOR PALETTE DEFINITIONS ---
const Color primaryRed = Color(0xFFC72F3A);
const Color darkText = Color(0xFF333333);
const Color lightGrayText = Color(0xFF9E9E9E);

class TutorialDetailPage extends StatelessWidget {
  final Tutorial tutorial;

  const TutorialDetailPage({super.key, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tutorial.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image/Video Placeholder ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://sakshamdigitaltechnology.com/uploads/tutorials/${tutorial.image}",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: primaryRed.withOpacity(0.1),
                  child: const Center(
                      child: Icon(Icons.videocam_off, color: primaryRed, size: 50)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Tutorial Title ---
            Text(
              tutorial.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(height: 8),

            // --- Rating and Educator ---
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  "${tutorial.ratingStar.toStringAsFixed(1)} (${tutorial.ratingCount} ratings)",
                  style: const TextStyle(fontSize: 16, color: darkText),
                ),
                const Spacer(),
                Text(
                  "By: ${tutorial.educatorName}",
                  style: const TextStyle(fontSize: 16, color: darkText),
                ),
              ],
            ),
            const Divider(height: 30, color: lightGrayText),

            // --- Details Card ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Page Name:", tutorial.pageName),
                    _buildDetailRow("Status:", tutorial.status),
                    _buildDetailRow("Topics:", tutorial.activeTopicsCount.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Start Tutorial Button ---
            ElevatedButton.icon(
              onPressed: () {
                // Logic to start the video/tutorial content
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Starting: ${tutorial.title}")),
                );
              },
              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
              label: const Text(
                "Start Tutorial",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: lightGrayText,
            ),
          ),
        ],
      ),
    );
  }
}