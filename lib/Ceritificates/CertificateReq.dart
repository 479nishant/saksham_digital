import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color primaryRed = Color(0xFFE91E63);
const Color backgroundGray = Color(0xFFF9F9F9);
const Color darkText = Colors.black;

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
          Uri.parse("https://sakshamdigitaltechnology.com/api/certificate/request"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestData),
        );

        setState(() => _loading = false);

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Certificate request submitted!")),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ Failed: ${response.body}")),
          );
        }
      } catch (e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Error: $e")),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryRed,
              onPrimary: Colors.white,
              onSurface: darkText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text =
        "${picked.year}-${_twoDigits(picked.month)}-${_twoDigits(picked.day)}";
      });
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
        bool required = true,
        bool isDate = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: isDate,
        style: const TextStyle(color: darkText), // text color
        keyboardType: keyboardType,
        validator: required
            ? (value) => value!.isEmpty ? "Enter $label" : null
            : null,
        onTap: isDate ? () => _selectDate(context, controller) : null,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: darkText), // hint text color
          labelText: label,
          labelStyle: const TextStyle(color: darkText), // label text color
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          suffixIcon: isDate
              ? const Icon(Icons.calendar_today, size: 18, color: primaryRed)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryRed),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryRed, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: AppBar(
        title: const Text(
          "Certificate Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryRed),
        titleTextStyle: const TextStyle(color: primaryRed, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(_studentNameController, "Student Name"),
                  _buildTextField(_mobileController, "Mobile",
                      keyboardType: TextInputType.phone),
                  _buildTextField(_courseNameController, "Course Name"),
                  _buildTextField(_emailController, "Email",
                      keyboardType: TextInputType.emailAddress),
                  _buildTextField(_dobController, "Date of Birth", isDate: true),
                  _buildTextField(_startDateController, "Start Date", isDate: true),
                  _buildTextField(_completionDateController, "Completion Date", isDate: true),
                  _buildTextField(_yearController, "Year"),
                  _buildTextField(_notesController, "Notes", required: false),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      onPressed: _loading ? null : _submitForm,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
