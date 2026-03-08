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
  final Color kDeepGreen = const Color(0xFF1B5E20);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await _api.signUp({
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "username": _userController.text,
      "email": _emailController.text,
      "password": _passController.text,
      "re_password": _confirmPassController.text,
    });

    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created! Please login.")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register Staff"),
        backgroundColor: kDeepGreen,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: isLandscape
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildHeader()),
                const SizedBox(width: 40),
                Expanded(child: _buildSignupForm()),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildSignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_add, size: 90, color: kDeepGreen),
        const SizedBox(height: 20),
        Text("CREATE ACCOUNT", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDeepGreen, letterSpacing: 1.2)),
        const Text("Join the Milki Flour ERP team", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildField(_firstNameController, "First Name", Icons.person_outline)),
              const SizedBox(width: 10),
              Expanded(child: _buildField(_lastNameController, "Last Name", Icons.person_outline)),
            ],
          ),
          const SizedBox(height: 20),
          _buildField(_userController, "Username", Icons.account_box_outlined),
          const SizedBox(height: 20),
          _buildField(_emailController, "Email", Icons.email_outlined, isEmail: true),
          const SizedBox(height: 20),
          _buildField(_passController, "Password", Icons.lock_outline, isPassword: true),
          const SizedBox(height: 20),
          _buildField(_confirmPassController, "Confirm Password", Icons.lock_reset, isPassword: true, isConfirm: true),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kDeepGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isLoading ? null : _handleSignup,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("REGISTER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, bool isEmail = false, bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kDeepGreen),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: kDeepGreen, width: 2)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Required";
        if (isEmail && !v.contains("@")) return "Invalid email";
        if (isConfirm && v != _passController.text) return "Passwords do not match";
        return null;
      },
    );
  }
}