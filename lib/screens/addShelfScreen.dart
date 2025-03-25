import 'package:digital_library/models/shelfModel.dart';
import 'package:flutter/material.dart';

/// A screen that shows a modal dialog to create a new shelf.
/// It returns a [Shelf] object back to the calling widget upon submission.
class addShelfScreen extends StatefulWidget {
  const addShelfScreen({super.key});

  @override
  State<addShelfScreen> createState() => _addShelfScreenState();
}

class _addShelfScreenState extends State<addShelfScreen> {
  /// Controller to handle input for shelf name
  final TextEditingController _shelfName = TextEditingController();

  /// Called when the user taps the 'Add' button.
  /// If the input is not empty, pops the dialog and returns a Shelf object.
  void _submitShelf() {
    final shelfName = _shelfName.text.trim();
    if (shelfName.isNotEmpty) {
      Navigator.of(context).pop(Shelf(name: shelfName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Create a New Shelf"),
      content: TextField(
        controller: _shelfName,
        decoration: InputDecoration(hintText: "Enter shelf name"),
      ),
      actions: [
        // Button to cancel and close the dialog without creating a shelf
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
        // Button to submit the shelf creation
        ElevatedButton(onPressed: _submitShelf, child: Text("Add")),
      ],
    );
  }
}
