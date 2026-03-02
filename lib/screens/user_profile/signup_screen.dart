import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController(); // New Controller

  bool _isLoading = false;
  final Color kDeepGreen = const Color(0xFF1B5E20);

  void _handleSignup() async {
    // 1. Validate Form (Includes the password match check below)
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _api.signUp({
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "username": _userController.text,
      "email": _emailController.text,
      "password": _passController.text,
      "re_password":
          _confirmPassController.text, // Sending both to Django/Djoser
    });

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please login.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup failed. Check details or connection."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Staff"),
        backgroundColor: kDeepGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Staff Credentials",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Fields
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      _firstNameController,
                      "First Name",
                      Icons.person,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildField(
                      _lastNameController,
                      "Last Name",
                      Icons.person,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Identity Fields
              _buildField(_userController, "Username", Icons.account_box),
              const SizedBox(height: 15),
              _buildField(
                _emailController,
                "Email",
                Icons.email,
                isEmail: true,
              ),
              const SizedBox(height: 15),

              // PASSWORD FIELD
              _buildField(
                _passController,
                "Password",
                Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 15),

              // CONFIRM PASSWORD FIELD
              TextFormField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_reset, color: kDeepGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please confirm password";
                  if (value != _passController.text)
                    return "Passwords do not match";
                  return null;
                },
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kDeepGreen),
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kDeepGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Required";
        if (isEmail && !v.contains("@")) return "Invalid email";
        if (isPassword && v.length < 8) return "Min 8 characters";
        return null;
      },
    );
  }
}
