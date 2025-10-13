import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../MODELS/TutorialsResponse.dart'; // Ensure this file exists
import 'TutorialDetailPage.dart';
import 'TutorialsResponses.dart';

// --- COLOR PALETTE ---
const Color primaryRed = Color(0xFFE91E63);
const Color darkText = Color(0xFF333333);
const Color lightGrayText = Color(0xFF9E9E9E);

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  List<Tutorial> tutorials = [];
  bool isLoading = true;
  String? errorMessage;

  // Updated base URL (correct folder name)
  final String baseImageUrl =
      "https://sakshamdigitaltechnology.com/uploads/tutorial/";

  @override
  void initState() {
    super.initState();
    fetchTutorials();
  }

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

  Widget buildTutorialItem(Tutorial tutorial) {
    final String imageUrl = baseImageUrl + tutorial.image;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialDetailPage(tutorial: tutorial),
          ),
        );
      },
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: primaryRed.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Thumbnail with play icon ---
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: primaryRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.videocam_outlined,
                          color: primaryRed,
                          size: 40,
                        ),
                      ),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: lightGrayText.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: primaryRed,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),

              // --- Text info ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutorial.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Educator: ${tutorial.educatorName}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: lightGrayText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${tutorial.ratingStar.toStringAsFixed(1)}  (${tutorial.ratingCount})",
                          style: const TextStyle(
                            fontSize: 13,
                            color: lightGrayText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: primaryRed.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: primaryRed, size: 40),
          const SizedBox(height: 10),
          Text(
            errorMessage ?? "Something went wrong",
            style: const TextStyle(color: darkText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fetchTutorials,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Retry",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Text(
        "No tutorials found.",
        style: TextStyle(color: darkText, fontSize: 16),
      ),
    );
  }

  Widget buildTutorialList() {
    return RefreshIndicator(
      onRefresh: fetchTutorials,
      color: primaryRed,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        itemCount: tutorials.length,
        itemBuilder: (context, index) {
          return buildTutorialItem(tutorials[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        title: const Text(
          "Tutorials",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: primaryRed),
      )
          : errorMessage != null
          ? buildErrorState()
          : tutorials.isEmpty
          ? buildEmptyState()
          : buildTutorialList(),
    );
  }
}
