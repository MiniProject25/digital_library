import 'package:digital_library/services/BookServices.dart';
import 'package:flutter/material.dart';

class addBookScreen extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController authorController;
  final Function(String) onBookAdded;
  final String shelfId;

  const addBookScreen({
    Key? key, 
    required this.nameController,
    required this.authorController,
    required this.onBookAdded,
    required this.shelfId,
  }) : super(key: key);

  @override
  State<addBookScreen> createState() => _addBookScreenState();
}

class _addBookScreenState extends State<addBookScreen> {
  bookServices bService = bookServices();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a book"),
      content: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          // name of the book field
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(hintText: "Book title"),
          ),
          // name of the author field
          TextField(
            controller: widget.authorController,
            decoration: InputDecoration(hintText: "Author name"),
          ),

          /// upload the PDF file here
          MaterialButton(
            onPressed: () => bService.uploadBook(context),
            child: Text('Upload a file'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () => bService.addBook(context, widget.nameController, widget.authorController, widget.shelfId),
          child: Text("Add"),
        ),
      ],
    );
  }
}
