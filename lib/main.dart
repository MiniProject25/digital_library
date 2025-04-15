import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/screens/addShelfScreen.dart';
import 'package:digital_library/screens/homeScreen.dart';
import 'package:digital_library/screens/shelfScreen.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(90, 198, 244, 1),
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          bodySmall: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],

      initialRoute: '/',
      // Static routes — for screens that DON'T need arguments
      routes: {
        '/': (context) => const homeScreen(),
        '/addShelf': (context) => const addShelfScreen(),
      },

      // Dynamic routes — for screens that NEED arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/shelfScreen') {
          final shelf = settings.arguments as Shelf;
          return MaterialPageRoute(
            builder: (context) => shelfScreen(shelf: shelf),
          );
        }

        // Optional: fallback route
        return MaterialPageRoute(
          builder: (context) => const homeScreen(),
        );
      },
    );
  }
}
