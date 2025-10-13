import 'package:flutter/material.dart';
import '../Video player/VideoPlayerPage.dart'; // <-- your video player page
import '../MODELS/TutorialsResponse.dart';

const Color primaryRed = Color(0xFFE91E63);
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
            // --- Tutorial image ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://sakshamdigitaltechnology.com/uploads/tutorial/${tutorial.image}",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: primaryRed.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.videocam_off, color: primaryRed, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Title ---
            Text(
              tutorial.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: primaryRed,
              ),
            ),
            const SizedBox(height: 8),

            // --- Rating ---
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  "${tutorial.ratingStar.toStringAsFixed(1)} (${tutorial.ratingCount} ratings)",
                  style: const TextStyle(fontSize: 16, color: darkText),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // --- Educator on a separate line ---
            Text(
              "By: ${tutorial.educatorName}",
              style: const TextStyle(fontSize: 16, color: darkText),
            ),
            const Divider(height: 30, color: lightGrayText),

            // --- Tutorial details card ---
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

            // --- Start tutorial button ---
            ElevatedButton.icon(
              onPressed: () {
                if (tutorial.video.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No video available")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      videoUrl:
                      "https://sakshamdigitaltechnology.com/uploads/tutorial/${tutorial.video}",
                      title: tutorial.title,
                    ),
                  ),
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
