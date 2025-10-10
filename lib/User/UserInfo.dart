import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserInfoPage extends StatefulWidget {
  const UpdateUserInfoPage({super.key});

  @override
  State<UpdateUserInfoPage> createState() => _UpdateUserInfoPageState();
}

class _UpdateUserInfoPageState extends State<UpdateUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  File? _imageFile;
  String? _profileImageUrl; // for saved image
  String? _token;
  final Color _primaryColor = const Color(0xFFE91E63);

  @override
  void initState() {
    super.initState();
    _loadUserData();

  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _nameController.text = prefs.getString('user_name') ?? '';
      _addressController.text = prefs.getString('user_address') ?? '';
      _cityController.text = prefs.getString('user_city') ?? '';
      _stateController.text = prefs.getString('user_state') ?? '';
      _pincodeController.text = prefs.getString('user_pincode') ?? '';
      _dobController.text = prefs.getString('user_dob') ?? '';
      _profileImageUrl = prefs.getString('user_image');
    });
    print("Name: ${prefs.getString('user_name')}");
    print("DOB: ${prefs.getString('user_dob')}");
    print("Address: ${prefs.getString('user_address')}");
    print("City: ${prefs.getString('user_city')}");
    print("State: ${prefs.getString('user_state')}");
    print("Pincode: ${prefs.getString('user_pincode')}");

  }

  // Update profile via API
  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      var uri = Uri.parse('https://www.sakshamdigitaltechnology.com/api/user-profile');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['name'] = _nameController.text;
      request.fields['dob'] = _dobController.text;
      request.fields['address'] = _addressController.text;
      request.fields['city'] = _cityController.text;
      request.fields['state'] = _stateController.text;
      request.fields['pincode'] = _pincodeController.text;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          final jsonResp = jsonDecode(respStr);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );

          // Save updated values
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('user_name', _nameController.text);
          prefs.setString('user_address', _addressController.text);
          prefs.setString('user_city', _cityController.text);
          prefs.setString('user_state', _stateController.text);
          prefs.setString('user_pincode', _pincodeController.text);
          prefs.setString('user_dob', _dobController.text);

          // If API returns image URL, save it too
          if (jsonResp['user']?['image'] != null) {
            prefs.setString('user_image', jsonResp['user']['image']);
            setState(() {
              _profileImageUrl = jsonResp['user']['image'];
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update failed: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: _primaryColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Image
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty)
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/profile.png') as ImageProvider,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(_nameController, 'Name', 'Enter your name'),
                  const SizedBox(height: 16),
                  _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)', null),
                  const SizedBox(height: 16),
                  _buildTextField(_addressController, 'Address', null),
                  const SizedBox(height: 16),
                  _buildTextField(_cityController, 'City', null),
                  const SizedBox(height: 16),
                  _buildTextField(_stateController, 'State', null),
                  const SizedBox(height: 16),
                  _buildTextField(_pincodeController, 'Pincode', null, TextInputType.number),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget _buildTextField(TextEditingController controller, String label, String? validatorMsg,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      validator: validatorMsg != null ? (v) => v!.isEmpty ? validatorMsg : null : null,
    );
  }
}
