// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum AppTheme { light, dark, purple }

/// purple theme
const Color _purplePrimary = Colors.deepPurple;
const Color _purpleSecondary = Colors.deepPurpleAccent;
const Color _purpleBackground = Color(0xFFEDE7F6);

/// light theme
const Color _lightPrimary = Color(0xFF03DAC6);
const Color _lightSecondary = Color.fromARGB(255, 106, 244, 230);
const Color _lightBackground = Color(0xFFFFFFFF);

/// dark theme (black & white theme)
const Color _darkPrimary = Color.fromARGB(255, 0, 0, 0);
const Color _darkSecondary = Color.fromARGB(255, 0, 0, 0);
const Color _darkBackground = Color.fromARGB(255, 255, 255, 255);

/// Gradient For Backgrounds
/// 
LinearGradient backgroundGradient = LinearGradient(
  colors: [
    // ignore: duplicate_ignore
    // ignore: deprecated_member_use
    _purpleBackground.withOpacity(0.8),
    Colors.white.withOpacity(0.3),
  ],
  stops: [0.1, 0.6],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// Gradient for AppBars and Buttons
/// 
LinearGradient purpleGradient = LinearGradient(
  colors: [
    _purplePrimary,
    _purpleSecondary,
    Colors.purpleAccent.shade100,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Building a ThemeData for each theme
/// 
ThemeData purpleTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: _purplePrimary,
    secondary: const Color.fromARGB(255, 107, 70, 209),
    background: _purpleBackground,
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    elevation: 0,
  ),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: _lightPrimary,
    secondary: _lightSecondary,
    background: _lightBackground,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: _darkPrimary,
    secondary: _darkSecondary,
    background: _darkBackground,
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = purpleTheme; // Default theme is Purple
  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
