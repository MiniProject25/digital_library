import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/themes.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.themeType;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: purpleGradient),
        ),
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255),
          fontSize: 25,
          fontFamily: 'Poppins',
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        toolbarHeight: 100,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // body
      body: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 5.0),
        child: Column(
          children: [
            ListTile(
              title: Text("Change Themes"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Themes"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<AppTheme>(
                            title: Text("Light Theme"),
                            value: AppTheme.light,
                            groupValue: currentTheme,
                            onChanged: (theme) {
                              if (theme != null) {
                                themeProvider.setTheme(theme);
                                Navigator.of(context).pop(); // Close dialog
                              }
                            },
                          ),
                          RadioListTile<AppTheme>(
                            title: Text("Dark Theme"),
                            value: AppTheme.dark,
                            groupValue: currentTheme,
                            onChanged: (theme) {
                              if (theme != null) {
                                themeProvider.setTheme(theme);
                                Navigator.of(context).pop(); // Close dialog
                              }
                            },
                          ),
                          RadioListTile<AppTheme>(
                            title: Text("Purple Theme (Default)"),
                            value: AppTheme.purple,
                            groupValue: currentTheme,
                            onChanged: (theme) {
                              if (theme != null) {
                                themeProvider.setTheme(theme);
                                Navigator.of(context).pop(); // Close dialog
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
