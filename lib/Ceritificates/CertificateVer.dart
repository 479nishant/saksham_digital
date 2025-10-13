import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Color primaryRed = Color(0xFFE91E63);
const Color lightGrey = Color(0xFFF0F0F0);

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
          _responseMessage = "Verification Success ✅";
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
      onTap: onTap,
      keyboardType: keyboardType,
      validator: required
          ? (value) => value == null || value.isEmpty ? "Enter $label" : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: lightGrey,
        labelStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryRed.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryRed, width: 2),
        ),
      ),
    );
  }

  Widget _buildResponseCard() {
    if (_responseMessage == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _responseData != null ? Colors.green : Colors.red,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _responseMessage!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _responseData != null ? Colors.green[800] : Colors.red[800],
            ),
          ),
          const SizedBox(height: 16),
          if (_responseData != null)
            Column(
              children: [
                _buildInfoRow("Certificate No", _responseData!["certificate_number"] ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("Name", _responseData!["name"] ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("Date of Birth", _responseData!["dob"] ?? "-"),
                const SizedBox(height: 8),
                _buildInfoRow("Course", _responseData!["course"] ?? "-"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Certificate Verification",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(_certNumberController, "Certificate Number"),
                  const SizedBox(height: 16),
                  _buildTextField(
                    _dobController,
                    "Date of Birth",
                    readOnly: true,
                    onTap: _pickDob,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _verifyCertificate,
                      child: const Text(
                        "Verify Certificate",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  _buildResponseCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
