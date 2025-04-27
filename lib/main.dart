import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/screens/addShelfScreen.dart';
import 'package:digital_library/screens/homeScreen.dart';
import 'package:digital_library/screens/shelfScreen.dart';
import 'package:digital_library/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
    // MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.currentTheme,

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
