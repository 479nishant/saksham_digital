import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Import the new model
 // ASSUME you placed the provided model here

// Import the new detail page
import '../MODELS/TutorialsResponse.dart';
import 'TutorialDetailPage.dart'; // ASSUME this path is correct

// --- COLOR PALETTE DEFINITIONS (Consistent with all other pages) ---
const Color primaryRed = Color(0xFFC72F3A); // Deep Red from the design
const Color darkText = Color(0xFF333333); // For general dark text
const Color lightGrayText = Color(0xFF9E9E9E); // For subtle text

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  // Use the Tutorial model list instead of dynamic list
  List<Tutorial> tutorials = [];
  bool isLoading = true;
  String? errorMessage;

  final String baseImageUrl = "https://sakshamdigitaltechnology.com/uploads/tutorials/";

  @override
  void initState() {
    super.initState();
    fetchTutorials();
  }

  // Modified to use the TutorialsResponse model
  Future<void> fetchTutorials() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse("https://www.sakshamdigitaltechnology.com/api/tutorials"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tutorialsResponse = TutorialsResponse.fromJson(data);

        setState(() {
          tutorials = tutorialsResponse.tutorials;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network Error: $e";
        isLoading = false;
      });
    }
  }

  // Modified to accept Tutorial model
  Widget buildTutorialItem(Tutorial tutorial) {
    String imageUrl = baseImageUrl + tutorial.image;

    return GestureDetector(
      // --- MODIFIED: Navigate to TutorialDetailPage ---
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialDetailPage(tutorial: tutorial),
          ),
        );
      },
      // -----------------------------------------------
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primaryRed.withOpacity(0.1), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // --- Image/Placeholder ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: primaryRed.withOpacity(0.1),
                    child: const Icon(Icons.videocam_outlined, color: primaryRed, size: 30),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 70,
                      height: 70,
                      color: lightGrayText.withOpacity(0.2),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryRed,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),

              // --- Title and Subtitle ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title, // Access title via model
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Educator: ${tutorial.educatorName}", // Access educatorName via model
                      style: const TextStyle(
                        fontSize: 14,
                        color: lightGrayText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Display Rating Star and Count
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "${tutorial.ratingStar.toStringAsFixed(1)} (${tutorial.ratingCount})",
                          style: const TextStyle(
                            fontSize: 12,
                            color: lightGrayText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // --- Arrow Icon ---
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: primaryRed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: const CircularProgressIndicator(color: primaryRed))
        : errorMessage != null
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: primaryRed, size: 40),
          const SizedBox(height: 10),
          Text(errorMessage!, style: const TextStyle(color: darkText)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fetchTutorials,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    )
        : tutorials.isEmpty
        ? const Center(
        child: Text("No tutorials found.", style: TextStyle(color: darkText))
    )
        : RefreshIndicator(
      onRefresh: fetchTutorials,
      color: primaryRed,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 4),
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          return buildTutorialItem(tutorials[index]);
        },
      ),
    );
  }
}