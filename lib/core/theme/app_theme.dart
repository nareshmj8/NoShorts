import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF4361EE);
  static const Color secondaryColor = Color(0xFF7209B7);
  static const Color textColor = Color(0xFF6B7280);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w300,
        fontSize: 18,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      bodySmall: TextStyle(
        color: Color(0x80000000),
        fontSize: 14,
      ), // 50% opacity black
    ),
    useMaterial3: true,
  );
}
