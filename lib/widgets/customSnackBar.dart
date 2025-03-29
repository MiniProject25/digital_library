import 'package:flutter/material.dart';

class Customsnackbar {
  static void show(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red, 
        duration: Duration(seconds: 2),
      ),
    );
  }
}