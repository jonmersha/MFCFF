import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _api = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Controllers for all Django AbstractUser fields
  late TextEditingController _userController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  bool _isLoading = true;
  bool _isSaving = false;
  final Color kDeepGreen = const Color(0xFF1B5E20);

  @override
  void initState() {
    super.initState();
    _userController = TextEditingController();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await _api.getCurrentUser();
      setState(() {
        _userController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading profile data")),
      );
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Prepare data payload matching Django keys
    final Map<String, String> updateData = {
      "username": _userController.text,
      "email": _emailController.text,
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
    };

    final success = await _api.updateProfile(updateData);
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update failed. Please check your connection."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Staff Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kDeepGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${_firstNameController.text} ${_lastNameController.text}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kDeepGreen,
                      ),
                    ),
                    const Text(
                      "Milki Food Complex Staff",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      _firstNameController,
                      "First Name",
                      Icons.badge_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _lastNameController,
                      "Last Name",
                      Icons.badge_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _userController,
                      "Username",
                      Icons.alternate_email,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      _emailController,
                      "Email",
                      Icons.email_outlined,
                      isEmail: true,
                    ),

                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDeepGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isSaving ? null : _handleUpdate,
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "SAVE CHANGES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kDeepGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kDeepGreen, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "This field is required";
        if (isEmail && !value.contains("@"))
          return "Enter a valid email address";
        return null;
      },
    );
  }
}
