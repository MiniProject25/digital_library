import 'package:flutter/material.dart';

/// A reusable widget that represents a single shelf as a card.
///
/// This widget is typically used in a grid or list of shelves. It shows the
/// shelf title and responds to tap gestures.
///
/// [title] - The name/title of the shelf to be displayed.
/// [onTap] - Callback function to be executed when the card is tapped.
class shelfCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const shelfCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3)
            ),
          ]
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
