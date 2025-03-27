import 'package:flutter/material.dart';
import 'package:digital_library/models/shelfModel.dart';

class shelfServices {
  /// Called when the user taps the 'Add' button.
  /// If the input is not empty, pops the dialog and returns a Shelf object.
  void submitShelf(BuildContext context, TextEditingController _shelfName) {
    final shelfName = _shelfName.text.trim();
    if (shelfName.isNotEmpty) {
      Navigator.of(context).pop(Shelf(name: shelfName));
    }
  }

  void deleteShelf(BuildContext context) {
    /// Logic to remove
    /// Remove the shelf from the shared Prefs and remove the widget
    Navigator.pop(context, 'delete');
  }
}
