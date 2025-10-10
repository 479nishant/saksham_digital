import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

import '../MODELS/CoursesModel.dart';
import 'courses_page.dart';



const Color primaryRed = Color(0xFFE91E63);
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkText = Color(0xFF333333);
const Color lightGrayText = Color(0xFF9E9E9E);

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<List<Course>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
  }

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(
      Uri.parse("https://www.sakshamdigitaltechnology.com/api/courses"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["courses"] != null) {
        final List<dynamic> courseList = data["courses"];
        return courseList.map((json) => Course.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load courses");
    }
  }

  String parseHtmlString(String? htmlString) {
    if (htmlString == null) return "No description available";
    return parse(htmlString).body!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(color: primaryRed),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryRed),
        elevation: 0,
      ),
      body: FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryRed),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: primaryRed),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No courses available", style: TextStyle(color: darkText)),
            );
          }

          final courses = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: courses.map((course) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(course: course),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryRed.withOpacity(0.3), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                      children: [
                        Text(
                          course.courseName ?? "Unnamed Course",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryRed,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          parseHtmlString(course.description),
                          style: const TextStyle(
                            fontSize: 14,
                            color: lightGrayText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.arrow_forward_ios, color: primaryRed, size: 18),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
