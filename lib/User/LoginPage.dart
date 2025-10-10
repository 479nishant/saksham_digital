import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';
import 'ForgetPass.dart';
import '../MODELS/LoginModel.dart';

// --- COLOR PALETTE DEFINITIONS ---
// Based on the deep red from the logo/button and the background/card.
const Color primaryRed = Color(0xFFC72F3A); // Deep Red from the design
const Color lightGrayBackground = Color(0xFFF5F5F5); // Very light gray screen background
const Color darkText = Color(0xFF333333); // For general dark text
const Color hintText = Color(0xFF9E9E9E); // For text field hints

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _saveSess();
    Timer(const Duration(seconds: 2), () {
      // Use 'b' from _saveSess for navigation check
      if (b == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  bool b = false;
  Future<void> _saveSess() async {
    final mprefs = await SharedPreferences.getInstance();
    // Safely retrieve the boolean, defaulting to false if null
    b = mprefs.getBool('isLoggedIn') ?? false;
  }

  LoginResponse? data;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Save everything in SharedPreferences
  Future<void> _saveSession(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', loginResponse.token);
    await prefs.setBool('isLoggedIn', true); // Use 'isLoggedIn' for clear session check
    await prefs.setString('message', loginResponse.message);

    await prefs.setInt('user_id', loginResponse.user.id);
    await prefs.setString('user_name', loginResponse.user.name);
    await prefs.setString('user_email', loginResponse.user.email);
    await prefs.setString('user_phone', loginResponse.user.phone);
    await prefs.setString('user_type', loginResponse.user.userType);
    await prefs.setInt('user_status', loginResponse.user.status);

    await prefs.setInt('user_final_marks', loginResponse.user.finalMarks ?? 0);
    await prefs.setString('user_address', loginResponse.user.address ?? '');
    await prefs.setString('user_city', loginResponse.user.city ?? '');
    await prefs.setString('user_state', loginResponse.user.state ?? '');
    await prefs.setString('user_pincode', loginResponse.user.pincode ?? '');
    await prefs.setString('user_image', loginResponse.user.image ?? '');
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Dismiss the keyboard before showing loading
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);

      final loginData = {
        "email": _emailController.text.trim(),
        "password": _passwordController.text.trim(),
      };
      const String url = "https://sakshamdigitaltechnology.com/api/login";

      try {
        final response = await http.post(Uri.parse(url), body: loginData);

        if (response.statusCode == 200) {
          final responseJson = jsonDecode(response.body);
          final loginResponse = LoginResponse.fromJson(responseJson);
          setState(() => data = loginResponse);

          // Save all data in SharedPreferences
          if (loginResponse.token.isNotEmpty) {
            await _saveSession(loginResponse);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login successful")),
            );
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        } else {
          // Attempt to parse error message if available, otherwise use status phrase
          final errorMessage = (response.body.isNotEmpty
              ? jsonDecode(response.body)['message']
              : null) ?? "Login failed. Check credentials.";

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Network Error: $e")),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Helper function for the custom InputDecoration theme
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: hintText),
      labelText: label, // Used labelText for better accessibility
      labelStyle: const TextStyle(color: darkText),
      prefixIcon: Icon(icon, color: primaryRed.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Smaller radius than before
        borderSide: const BorderSide(color: hintText),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
            color: primaryRed, width: 2.0), // Focus state with primary red
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrayBackground, // Use defined background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- LOGO/BRANDING (Placeholder for the image logo) ---
              // Replace this Text with your actual logo widget later
              const Text(
                'SAKSHAM',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'DIGITAL TECHNOLOGY',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: primaryRed,
                ),
              ),
              const SizedBox(height: 40),

              // --- LOGIN CARD ---
              Card(
                color: Colors.white,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- WELCOME TEXT ---
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryRed,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Please login to your account',
                          style: TextStyle(
                            fontSize: 14,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 30.0),

                        // --- EMAIL FIELD ---
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration('Email', Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // --- PASSWORD FIELD ---
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: _inputDecoration('Password', Icons.lock_outline)
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primaryRed,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),

                        // --- REMEMBER ME & FORGOT PASSWORD ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Aligned to the right as in the design
                          children: <Widget>[
                            // You can add the "Remember me" checkbox here if needed,
                            // but I'm focusing on "Forgot Password" to match the image layout.
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: primaryRed,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),

                        // --- LOGIN BUTTON ---
                        _isLoading
                            ? const Center(child: CircularProgressIndicator(color: primaryRed))
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // --- SIGN UP & SOCIAL ICONS ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Add navigation to your Sign Up page here
                                print("Navigate to Sign Up");
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: primaryRed, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        // Social Media Icons Row (Placeholder - kept simple)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildSocialIcon(Icons.facebook),
                            _buildSocialIcon(Icons.g_mobiledata),
                            _buildSocialIcon(Icons.apple),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Note: I'm keeping the API debug info simple or removing it in a final design
              // if (data != null)
              //   ... (your original data display card)
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for social media icons
  Widget _buildSocialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primaryRed.withOpacity(0.5)),
        ),
        child: Icon(icon, color: primaryRed, size: 24),
      ),
    );
  }
}
