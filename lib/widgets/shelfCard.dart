import 'package:flutter/material.dart';

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
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
} 
