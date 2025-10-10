import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../MODELS/InternshipTotal.dart';

// Adjust path as per your project

class InternshipPage extends StatefulWidget {
  const InternshipPage({Key? key}) : super(key: key);

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

class _InternshipPageState extends State<InternshipPage> {
  bool _isLoading = true;
  List<Applicant> _internships = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchInternships();
  }

  Future<void> fetchInternships() async {


    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {

      final response= await http.get(Uri.parse("https://www.sakshamdigitaltechnology.com/api/internship-forms"));

      print("hello");

      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        print(jsonData);
        setState(() {
          _internships = jsonData.map((e) => Applicant.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load internships: HTTP ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internships'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _internships.isEmpty
          ? const Center(child: Text('No internships found'))
          : ListView.builder(
        itemCount: _internships.length,
        itemBuilder: (context, index) {
          final applicant = _internships[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(applicant.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(applicant.fieldOfInterest),
                  const SizedBox(height: 4),
                  Text(applicant.educationalQualification),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to a detailed page or resume view
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InternshipDetailPage(applicant: applicant),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Optional detail page
class InternshipDetailPage extends StatelessWidget {
  final Applicant applicant;
  const InternshipDetailPage({Key? key, required this.applicant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(applicant.fullName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${applicant.email}', style: const TextStyle(fontSize: 16)),
            Text('Contact: ${applicant.contactNumber}', style: const TextStyle(fontSize: 16)),
            Text('Qualification: ${applicant.educationalQualification}', style: const TextStyle(fontSize: 16)),
            Text('Field of Interest: ${applicant.fieldOfInterest}', style: const TextStyle(fontSize: 16)),
            if (applicant.linkedinProfile != null)
              Text('LinkedIn: ${applicant.linkedinProfile}', style: const TextStyle(fontSize: 16, color: Colors.blue)),
            const SizedBox(height: 16),
            Text('Introduction:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(applicant.briefIntroduction),
          ],
        ),
      ),
    );
  }
}
