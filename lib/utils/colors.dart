import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color secondary = Color(0xFFF57C00);
  static const Color accent = Color(0xFFF57C00);
  static const Color background = Color(0xFFF8F9FA);
  static const Color card = Colors.white;
  static const Color text = Colors.black;
  static const Color textLight = Colors.grey;
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color liveRed = Color(0xFFFF1744);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF534BAE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Colors.white;
}
