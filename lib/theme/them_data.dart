import 'package:flutter/material.dart';

class ThemeProvider {
  // Định nghĩa các màu chính của ứng dụng
  static const Color primaryOrange = Color(0xFFE65100);
  static const Color secondaryOrange = Color(0xFFFF9800);
  static const Color lightOrange = Color(0xFFFFB557);
  static const Color darkOrange = Color(0xFFD84315);
  static const Color accentColor = Color(0xFF042D62);

  // Theme data chính của ứng dụng
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 18),
      headlineLarge: TextStyle(fontSize: 18),
      headlineMedium: TextStyle(fontSize: 18),
      headlineSmall: TextStyle(fontSize: 18),
      bodySmall: TextStyle(fontSize: 18),
      labelLarge: TextStyle(fontSize: 18),
      labelMedium: TextStyle(fontSize: 18),
      labelSmall: TextStyle(fontSize: 18),
      displayLarge: TextStyle(fontSize: 18),
      displayMedium: TextStyle(fontSize: 18),
      displaySmall: TextStyle(fontSize: 18),
      titleLarge: TextStyle(fontSize: 18),
      titleMedium: TextStyle(fontSize: 18),
      titleSmall: TextStyle(fontSize: 18),
    ),
  );
}
