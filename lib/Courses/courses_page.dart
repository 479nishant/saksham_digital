import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import '../MODELS/CoursesModel.dart';

// --- COLOR PALETTE ---
const Color primaryRed = Color(0xFFE91E63);
const Color darkText = Color(0xFF333333);
const Color lightGrayText = Color(0xFF9E9E9E);
const Color backgroundGray = Color(0xFFF5F5F5);

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  // Helper function to strip HTML
  String _parseHtmlString(String? htmlString) {
    if (htmlString == null) return "No description available";
    return parse(htmlString).body!.text;
  }

  // Helper function to format date
  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return "N/A";
    try {
      final date = DateTime.parse(dateTimeString);
      return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
    } catch (e) {
      return "N/A";
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: AppBar(
        title: Text(
          course.courseName ?? "Course Details",
          style: const TextStyle(color: primaryRed, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryRed),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Course Image with Skeleton Loader ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://sakshamdigitaltechnology.com/uploads/courses/${course.image}",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryRed,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: primaryRed.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: primaryRed, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Course Card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryRed.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    course.courseName ?? "Unnamed Course",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _parseHtmlString(course.description),
                    style: const TextStyle(
                      fontSize: 14,
                      color: lightGrayText,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Enroll Button ---
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enrollment feature coming soon!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Enroll Now",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Metadata Card (optional helper function) ---
  Widget _buildMetadataCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: darkText,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: lightGrayText,
            ),
          ),
        ],
      ),
    );
  }
}
