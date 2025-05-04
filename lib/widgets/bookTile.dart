import 'package:flutter/material.dart';
import '../models/bookModel.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookTile({Key? key, required this.book, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;  
    final ColorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: cardTheme.color,
      child: ListTile(
        title: Text(
          book.title,
          style: TextStyle(color: ColorScheme.primary, fontSize: 20),
        ),
        subtitle: Text(
          book.author,
          style: TextStyle(color: ColorScheme.secondary, fontSize: 14),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple.shade300,),
        onTap: onTap,
      ),
    );
  }
}