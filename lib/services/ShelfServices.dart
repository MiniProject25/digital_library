import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:uuid/uuid.dart';

/// Service class responsible for handling shelf-related operations such as
/// adding and deleting shelves using the local database.
class shelfServices {
  final Uuid uuid = Uuid();

  /// Submits a new shelf to the database.
  ///
  /// Called when the user taps the 'Add' button. Checks if the shelf name
  /// is not empty. If valid, creates a new [Shelf] object and inserts it
  /// into the database. Then pops the current dialog and returns the new shelf.
  ///
  /// [context] - The build context to access Navigator.
  /// [shelfName_] - Controller holding the shelf name entered by the user.
  void submitShelf(BuildContext context, TextEditingController shelfName_) async {
    final shelfName = shelfName_.text.trim();
    if (shelfName.isNotEmpty) {
      Shelf newShelf = Shelf(id: uuid.v1(), name: shelfName);
      await databaseHelper.instance.insertShelf(newShelf);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(newShelf);
    }
  }

  /// Deletes a shelf by its ID from the database.
  ///
  /// Also closes the current dialog or screen after deletion.
  ///
  /// [shelfId] - The ID of the shelf to be deleted.
  /// [context] - The build context to access Navigator.
  Future<void> deleteShelf(String shelfId, BuildContext context) async {
    await databaseHelper.instance.deleteShelf(shelfId);

    // cascade delete of the books
    await databaseHelper.instance.deleteBookByShelf(shelfId);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  /// Retrieves all shelves from the database.
  Future<List<Shelf>> getAllShelves() async {
    final db = await databaseHelper.instance.database;
    final List<Map<String, dynamic>> shelfMaps = await db.query('shelves');
    return shelfMaps.map((map) => Shelf.fromMap(map)).toList();
  }

  
}
