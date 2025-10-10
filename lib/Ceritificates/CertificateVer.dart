import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CertificateVerPage extends StatefulWidget {
  const CertificateVerPage({super.key});

  @override
  State<CertificateVerPage> createState() => _CertificateVerPageState();
}

class _CertificateVerPageState extends State<CertificateVerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _certNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _loading = false;
  String? _responseMessage;
  Map<String, dynamic>? _responseData;

  Future<void> _verifyCertificate() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "certificate_number": _certNumberController.text,
      "dob": _dobController.text,
    };

    setState(() {
      _loading = true;
      _responseMessage = null;
      _responseData = null;
    });

    try {
      final response = await http.post(
        Uri.parse("https://sakshamdigitaltechnology.com/api/certificate/verify"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      setState(() {
        _loading = false;
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          _responseData = body;
          _responseMessage = "Verification Success";
        });
      } else {
        String msg = "Error ${response.statusCode}";
        try {
          final body = jsonDecode(response.body);
          if (body is Map && body["message"] != null) {
            msg = body["message"].toString();
          }
        } catch (_) {}
        setState(() {
          _responseMessage = msg;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _responseMessage = "Exception: $e";
      });
    }
  }

  Future<void> _pickDob() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
        bool required = true,
        bool readOnly = false,
        VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      onTap: onTap,
      validator: required
          ? (value) => value == null || value.isEmpty ? "Enter $label" : null
          : null,
    );
  }

  Widget _buildResponseSection() {
    if (_responseMessage == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _responseMessage!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: (_responseData != null) ? Colors.green : Colors.red,
            ),
          ),
          if (_responseData != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                jsonEncode(_responseData),
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate Verify"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_certNumberController, "Certificate Number"),
              _buildTextField(
                _dobController,
                "Date of Birth",
                readOnly: true,
                onTap: _pickDob,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _verifyCertificate,
                child: const Text("Verify"),
              ),
              _buildResponseSection(),
            ],
          ),
        ),
      ),
    );
  }
}
