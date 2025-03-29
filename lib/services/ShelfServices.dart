import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:uuid/uuid.dart';

class shelfServices {
  final Uuid uuid = Uuid();
  /// Called when the user taps the 'Add' button.
  /// If the input is not empty, pops the dialog and returns a Shelf object.
  void submitShelf(BuildContext context, TextEditingController shelfName_) async {
    final shelfName = shelfName_.text.trim();
    if (shelfName.isNotEmpty) {
      Shelf newShelf = Shelf(id: uuid.v1(), name: shelfName);
      await databaseHelper.instance.insertShelf(newShelf);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(newShelf);
    }
  }

  Future<void> deleteShelf(String shelfId, BuildContext context) async {
    await databaseHelper.instance.deleteShelf(shelfId);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
