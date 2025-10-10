import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart'; // Navigate here after successful registration

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _responseMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final payload = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _passwordController.text.trim(),
      "password_confirmation": _confirmPasswordController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse("https://sakshamdigitaltechnology.com/api/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);

        // Optionally save token or info in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        if (body['token'] != null) {
          await prefs.setString('token', body['token']);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );

        // Navigate to Home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          _responseMessage = body['message'] ?? 'Registration failed!';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _responseMessage = "Error: $e";
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text,
        bool obscure = false,
        bool isPasswordField = false,
        VoidCallback? togglePassword}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
        prefixIcon: isPasswordField ? const Icon(Icons.lock) : null,
        suffixIcon: isPasswordField
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: togglePassword,
        )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Enter $label";
        if (label == "Email" &&
            !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return "Enter a valid email";
        if ((label == "Password" || label == "Confirm Password") && value.length < 6)
          return "Password must be at least 6 characters";
        if (label == "Confirm Password" && value != _passwordController.text)
          return "Passwords do not match";
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                "Saksham",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE91E63),
                ),
              ),
              const SizedBox(height: 32),
              Card(
                color: Colors.white,
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_nameController, "Full Name"),
                        const SizedBox(height: 16),
                        _buildTextField(_emailController, "Email",
                            inputType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        _buildTextField(_phoneController, "Phone",
                            inputType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildTextField(_passwordController, "Password",
                            obscure: !_isPasswordVisible,
                            isPasswordField: true,
                            togglePassword: () {
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            }),
                        const SizedBox(height: 16),
                        _buildTextField(_confirmPasswordController, "Confirm Password",
                            obscure: !_isConfirmPasswordVisible,
                            isPasswordField: true,
                            togglePassword: () {
                              setState(() =>
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                            }),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xFFE91E63),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (_responseMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _responseMessage!,
                            style: TextStyle(
                              color: _responseMessage!.contains("successful")
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
