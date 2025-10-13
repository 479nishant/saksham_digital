import 'dart:convert';
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

  String? _profileImageUrl;
  String? _token;
  final Color _primaryColor = const Color(0xFFE91E63);
  final String _baseImageUrl = 'https://www.sakshamdigitaltechnology.com/uploads/';
  bool _isEditing = false; // 👈 controls the update card visibility

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

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
  }

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

      try {
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          final jsonResp = jsonDecode(respStr);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_name', _nameController.text);
          await prefs.setString('user_address', _addressController.text);
          await prefs.setString('user_city', _cityController.text);
          await prefs.setString('user_state', _stateController.text);
          await prefs.setString('user_pincode', _pincodeController.text);
          await prefs.setString('user_dob', _dobController.text);

          if (jsonResp['user']?['image'] != null) {
            String imageUrl = jsonResp['user']['image'];
            if (!imageUrl.startsWith('http')) {
              imageUrl = '$_baseImageUrl$imageUrl';
            }
            await prefs.setString('user_image', imageUrl);
            setState(() => _profileImageUrl = imageUrl);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Profile updated successfully")),
          );

          setState(() => _isEditing = false); // hide form after success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("⚠️ Update failed: ${response.statusCode}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error updating profile: $e")),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_dobController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
        "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
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
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileInfoCard(),
            const SizedBox(height: 20),
            if (!_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => _isEditing = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            if (_isEditing) _buildUpdateFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                  ? NetworkImage(
                _profileImageUrl!.startsWith('http')
                    ? _profileImageUrl!
                    : '$_baseImageUrl${_profileImageUrl!}',
              )
                  : const AssetImage('assets/profile.png') as ImageProvider,
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Name', _nameController.text),
            _buildInfoRow('Date of Birth', _dobController.text),
            _buildInfoRow('Address', _addressController.text),
            _buildInfoRow('City', _cityController.text),
            _buildInfoRow('State', _stateController.text),
            _buildInfoRow('Pincode', _pincodeController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateFormCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 6,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, 'Name', 'Enter your name'),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      _dobController,
                      'Date of Birth (YYYY-MM-DD)',
                      'Select your date of birth',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField(_addressController, 'Address', null),
                const SizedBox(height: 10),
                _buildTextField(_cityController, 'City', null),
                const SizedBox(height: 10),
                _buildTextField(_stateController, 'State', null),
                const SizedBox(height: 10),
                _buildTextField(_pincodeController, 'Pincode', null, TextInputType.number),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _isEditing = false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: _primaryColor),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: _primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? validatorMsg, [
        TextInputType keyboardType = TextInputType.text,
      ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: Colors.black87),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryColor, width: 1.5),
        ),
      ),
      validator: validatorMsg != null ? (v) => v!.isEmpty ? validatorMsg : null : null,
    );
  }
}
