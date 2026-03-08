import 'package:flutter/material.dart';
import '../../screens/home/main_screen.dart';
import '../../services/api_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _api = ApiService();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  final Color kDeepGreen = const Color(0xFF1B5E20);
  bool _obscureText = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both username and password")),
      );
      return;
    }

    setState(() => _isLoading = true);
    bool success = await _api.login(_userController.text, _passController.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed. Check credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check orientation
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900), // Limits width on tablets/web
            child: isLandscape
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildHeader()),
                const SizedBox(width: 40),
                Expanded(child: _buildLoginForm()),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.precision_manufacturing, size: 90, color: kDeepGreen),
        const SizedBox(height: 20),
        Text(
          "MILKI FLOUR ERP",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kDeepGreen,
            letterSpacing: 1.2,
          ),
        ),
        const Text(
          "Secure Staff Portal",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _userController,
          decoration: InputDecoration(
            labelText: "Username",
            prefixIcon: Icon(Icons.person_outline, color: kDeepGreen),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kDeepGreen, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock_outline, color: kDeepGreen),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kDeepGreen, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 35),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDeepGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const SizedBox(
              height: 20, width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text("SIGN IN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignupScreen()),
          ),
          child: Text("Don't have an account? Sign Up", style: TextStyle(color: kDeepGreen)),
        ),
      ],
    );
  }
}