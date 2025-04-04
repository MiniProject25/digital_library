import 'package:digital_library/services/BookServices.dart';
import 'package:flutter/material.dart';

/// A modal dialog screen for adding a new book to a shelf.
///
/// This screen allows the user to input the book title and author name,
/// and upload a corresponding PDF file. Upon submission, the book is
/// added to the SQLite database via [bookServices].
class addBookScreen extends StatefulWidget {
  /// Controller for capturing the book title input.
  final TextEditingController nameController;

  /// Controller for capturing the author name input.
  final TextEditingController authorController;

  /// Callback to notify parent widget that a book has been added.
  final Function(String) onBookAdded;

  /// ID of the shelf where the book should be added.
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
  /// Service class responsible for handling book-related operations
  /// like uploading files and inserting book data into the database.
  bookServices bService = bookServices();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a book"),
      content: Column(
        // Ensures content fits nicely inside the alert dialog
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text field to enter book title
          TextField(
            controller: widget.nameController,
            decoration: InputDecoration(hintText: "Book title"),
          ),
          // Text field to enter author name
          TextField(
            controller: widget.authorController,
            decoration: InputDecoration(hintText: "Author name"),
          ),

          /// Button to trigger file picker and upload a PDF file.
          MaterialButton(
            onPressed: () => bService.uploadBook(context),
            child: Text('Upload a file'),
          ),
        ],
      ),
      actions: [
        // Closes the dialog without saving
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        
        /// Saves the book information using bookServices and closes the dialog.
        ElevatedButton(
          onPressed: () => bService.addBook(
            context,
            widget.nameController,
            widget.authorController,
            widget.shelfId,
          ),
          child: Text("Add"),
        ),
      ],
    );
  }
}
