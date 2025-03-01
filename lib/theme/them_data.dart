import 'package:flutter/material.dart';

class ThemeProvider {
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(), // Thêm const ở đây
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
