import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/services/ShelfServices.dart';
import 'package:flutter/material.dart';

/// A screen that shows a modal dialog to create a new shelf.
/// 
/// This dialog allows the user to input a shelf name. When submitted,
/// a [Shelf] object is created and returned to the calling widget via
/// [Navigator.pop()].
class addShelfScreen extends StatefulWidget {
  const addShelfScreen({super.key});

  @override
  State<addShelfScreen> createState() => _addShelfScreenState();
}

class _addShelfScreenState extends State<addShelfScreen> {
  /// Service to handle shelf-related database operations.
  shelfServices sService = shelfServices();

  /// Controller to handle user input for the shelf name.
  final TextEditingController _shelfName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New Shelf"),
      content: TextField(
        controller: _shelfName,
        decoration: InputDecoration(hintText: "Enter shelf name"),
      ),
      actions: [
        // Closes the dialog without saving
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        // Calls the shelf service to save the new shelf to database
        ElevatedButton(
          onPressed: () => sService.submitShelf(context, _shelfName),
          child: Text("Add"),
        ),
      ],
    );
  }
}
