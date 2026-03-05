import 'package:flutter/material.dart';

class AppTheme {
  static const Color kDeepGreen = Color(0xFF1B5E20);
  static const Color kCompanyYellow = Color(0xFFFFC107); // Secondary Brand Color
  static const Color kSurfaceBackground = Color(0xFFF8F9FA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',

      colorScheme: ColorScheme.fromSeed(
        seedColor: kDeepGreen,
        primary: kDeepGreen,
        secondary: kCompanyYellow, // Yellow mapped to Secondary
        onSecondary: Colors.black, // Text on yellow should be black for contrast
        surface: Colors.white,
        background: kSurfaceBackground,
      ),

      // Fixed: Using CardThemeData for the property name 'cardTheme'
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: kDeepGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Use Yellow for Floating Action Buttons (FAB)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kCompanyYellow,
        foregroundColor: Colors.black,
      ),

      // Button Theme: Primary buttons are Green, Secondary/Warning are Yellow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kDeepGreen,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}