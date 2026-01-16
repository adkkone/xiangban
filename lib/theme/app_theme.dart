import 'package:flutter/material.dart';

class AppTheme {
  static const Color vitalOrange = Color(0xFFFF8C42);
  static const Color energyRed = Color(0xFFFF3B30);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color darkGray = Color(0xFF1F2937);
  static const Color softGray = Color(0xFF9CA3AF);
  static const Color successGreen = Color(0xFF10B981);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: offWhite,
    fontFamily: '-apple-system',
    colorScheme: ColorScheme.fromSeed(
      seedColor: vitalOrange,
      primary: vitalOrange,
      secondary: energyRed,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: darkGray,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkGray,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkGray,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: softGray,
      ),
    ),
  );

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [vitalOrange, energyRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient backgroundGradient = LinearGradient(
    colors: [
      vitalOrange.withValues(alpha: 0.05),
      Colors.transparent,
    ],
    begin: Alignment.topCenter,
    end: Alignment.center,
  );
}
