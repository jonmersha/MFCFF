import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/main_screen/main_screen.dart';
import 'screens/user_profile/login_screen.dart'; // Ensure this is imported

void main() async {
  // 1. Required when using native plugins (like Secure Storage) before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize storage and check for existing token
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt_token');

  // 3. Pass the token status to the App widget
  runApp(MFCErp(isLoggedIn: token != null));
}

class MFCErp extends StatelessWidget {
  final bool isLoggedIn;

  // Constructor to receive the login status
  MFCErp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Milki Flour ERP',
      theme: ThemeData(
        // Using ColorScheme is the modern way to set primary colors in Flutter
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5D4037),
          primary: const Color(0xFF5D4037),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5D4037),
          foregroundColor: Colors.white,
        ),
      ),
      // 4. Conditional Home: Redirect based on token existence
      home: isLoggedIn ? MainScreen() : LoginScreen(),
    );
  }
}
