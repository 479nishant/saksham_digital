import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Certificatereq extends StatefulWidget {
  const Certificatereq({super.key});

  @override
  State<Certificatereq> createState() => _CertificatereqState();
}

class _CertificatereqState extends State<Certificatereq> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _completionDateController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _loading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "student_name": _studentNameController.text,
        "mobile": _mobileController.text,
        "course_name": _courseNameController.text,
        "email": _emailController.text,
        "dob": _dobController.text,
        "start_date": _startDateController.text,
        "completion_date": _completionDateController.text,
        "year": _yearController.text,
        "notes": _notesController.text,
      };

      setState(() => _loading = true);

      try {
        final response = await http.post(
          Uri.parse("https://sakshamdigitaltechnology.com/api/certificate/request"), // TODO: Replace with your API URL
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData),
        );

        setState(() => _loading = false);

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Certificate request submitted!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${response.body}")),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, bool required = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      validator: required
          ? (value) => value!.isEmpty ? "Enter $label" : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate Request"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_studentNameController, "Student Name"),
                _buildTextField(_mobileController, "Mobile",
                    keyboardType: TextInputType.phone),
                _buildTextField(_courseNameController, "Course Name"),
                _buildTextField(_emailController, "Email",
                    keyboardType: TextInputType.emailAddress),
                _buildTextField(_dobController, "Date of Birth (YYYY-MM-DD)"),
                _buildTextField(_startDateController, "Start Date (YYYY-MM-DD)"),
                _buildTextField(
                    _completionDateController, "Completion Date (YYYY-MM-DD)"),
                _buildTextField(_yearController, "Year"),
                _buildTextField(_notesController, "Notes", required: false),
                const SizedBox(height: 20),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
