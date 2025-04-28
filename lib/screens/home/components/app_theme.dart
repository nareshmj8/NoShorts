import 'package:flutter/material.dart';

class AppTheme {
  // Custom colors
  static const Color primaryColor = Color(0xFF7209B7);
  static const Color gradientStartColor = Color(0xFF4361EE);
  static const Color gradientEndColor = Color(0xFF7209B7);
  static const Color lightGray = Color(0xFFF5F5F5); // gray-100
  static const Color mediumGray = Color(0xFFE0E0E0); // gray-200
  static const Color goldLight = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFF5C518);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: gradientStartColor,
      tertiary: gradientEndColor,
      surface: Colors.white,
      background: Colors.white,
      surfaceVariant: lightGray,
      onSurface: Colors.black87,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: lightGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleSmall: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGray,
      prefixIconColor: primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  // Create a gradient decoration - optimized to be called less frequently
  static BoxDecoration createGradientDecoration({BorderRadius? borderRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
}
