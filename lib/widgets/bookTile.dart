import 'package:flutter/material.dart';
import '../models/bookModel.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookTile({Key? key, required this.book, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.deepPurple.shade50,
      child: ListTile(
        title: Text(
          book.title,
          style: TextStyle(color: Colors.deepPurple.shade800),
        ),
        subtitle: Text(
          book.author,
          style: TextStyle(color: Colors.deepPurple.shade400),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.deepPurple.shade300,),
        onTap: onTap,
      ),
    );
  }
}