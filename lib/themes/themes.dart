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
  textTheme: TextTheme(
    // titles in the appbar
    headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'),

    labelLarge: TextStyle(
      color: Colors.deepPurple,
      fontSize: 22,
      fontFamily: 'Poppins',
    ),

    // text in the body
    bodyMedium: TextStyle(
      color: Colors.deepPurple.shade900,
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),

    labelSmall: TextStyle(
      fontFamily: 'OpenSans',
      color: Colors.deepPurple,
      fontWeight: FontWeight.w900,
      fontSize: 14,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.deepPurple.shade500,
      ),
      foregroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.deepPurple.shade900.withOpacity(0.2);
          }
          return null;
        },
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 18,
          fontFamily: 'OpenSans',
          color: Colors.white,
        ),
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.deepPurple.shade50,
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
  // ignore: prefer_final_fields
  ThemeData _currentTheme = purpleTheme; // Default theme is Purple
  // ignore: prefer_final_fields
  AppTheme _currentAppTheme = AppTheme.purple; // Default theme is Purple

  ThemeData get currentTheme => _currentTheme; 
  AppTheme get themeType => _currentAppTheme;

  void setTheme(AppTheme theme) {
    _currentAppTheme = theme;
    switch(theme) {
      case AppTheme.light:
        _currentTheme = lightTheme;
        break;
      case AppTheme.dark:
        _currentTheme = darkTheme;
        break;
      case AppTheme.purple:
        _currentTheme = purpleTheme;
        break;
    }
    notifyListeners();
  }
}
