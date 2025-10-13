import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../MODELS/InternshipTotal.dart';

const Color primaryRed = Color(0xFFE91E63);
const Color darkText = Color(0xFF333333);
const Color lightGrayText = Color(0xFF9E9E9E);
const Color backgroundGray = Color(0xFFF9F9F9);
const Color lightGrey = Color(0xFFF0F0F0);

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
      final response = await http.get(
        Uri.parse("https://www.sakshamdigitaltechnology.com/api/internship-forms"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
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
      backgroundColor: backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryRed),
        title: const Text(
          'Internships',
          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
          : _errorMessage.isNotEmpty
          ? Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: primaryRed, fontSize: 16),
        ),
      )
          : _internships.isEmpty
          ? const Center(
        child: Text('No internships found', style: TextStyle(fontSize: 16)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _internships.length,
        itemBuilder: (context, index) {
          final applicant = _internships[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InternshipDetailPage(applicant: applicant),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: primaryRed.withOpacity(0.15), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applicant.fullName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    applicant.fieldOfInterest,
                    style: const TextStyle(
                        fontSize: 14, color: lightGrayText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    applicant.educationalQualification,
                    style: const TextStyle(
                        fontSize: 14, color: lightGrayText),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios,
                        color: primaryRed, size: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InternshipDetailPage extends StatelessWidget {
  final Applicant applicant;
  const InternshipDetailPage({Key? key, required this.applicant}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    // ensure URL is valid
    String finalUrl = url.trim();
    if (!finalUrl.startsWith('http') && !finalUrl.startsWith('mailto') && !finalUrl.startsWith('tel')) {
      finalUrl = 'https://$finalUrl';
    }

    final Uri uri = Uri.parse(finalUrl);

    if (await canLaunchUrl(uri)) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw 'Could not launch $finalUrl';
      }
    } else {
      throw 'Could not launch $finalUrl';
    }
  }

  Widget _buildClickableRow(String label, String value, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: primaryRed),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (type == 'email') {
                  _launchUrl('mailto:$value');
                } else if (type == 'phone') {
                  _launchUrl('tel:$value');
                } else if (type == 'linkedin') {
                  _launchUrl(value);
                }
              },
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: primaryRed),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: darkText),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryRed),
        title: Text(
          applicant.fullName,
          style: const TextStyle(
              color: darkText, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Full Name', applicant.fullName),
            _buildClickableRow('Email', applicant.email, 'email'),
            _buildClickableRow('Contact', applicant.contactNumber, 'phone'),
            _buildDetailRow('Qualification', applicant.educationalQualification),
            _buildDetailRow('Field of Interest', applicant.fieldOfInterest),
            if (applicant.linkedinProfile != null &&
                applicant.linkedinProfile!.isNotEmpty)
              _buildClickableRow('LinkedIn', applicant.linkedinProfile!, 'linkedin'),
            const SizedBox(height: 20),
            const Text(
              'Introduction',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: primaryRed),
            ),
            const SizedBox(height: 8),
            Text(
              applicant.briefIntroduction,
              style: const TextStyle(fontSize: 16, color: darkText, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
