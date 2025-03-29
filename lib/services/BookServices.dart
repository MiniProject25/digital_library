import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class bookServices {
  final uuid = Uuid();
  final databaseHelper _dbHelper = databaseHelper.instance;
  FilePickerResult? result;

  void searchBooks(TextEditingController searchController,
      Function(List<Book>) onSearchResult, List<Book> books) {
    final query = searchController.text.trim().toLowerCase();

    List<Book> results = books
        .where((book) => book.title.toLowerCase().contains(query))
        .toList();

    onSearchResult(results);
  }

  Future<void> addBook(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController authorController,
    String shelfId
  ) async {
    if (nameController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        result != null) {
      /// Add logic to insert a book into the Shelf
      DateTime date = DateTime.now();

      Book newBook = Book(
          id: uuid.v1(),
          title: nameController.text,
          author: authorController.text,
          addedOn: DateTime(date.year, date.month, date.day).toString(),
          filePath: result!.files.single.path ?? '',
          shelfId: shelfId);

      await _dbHelper.insertBook(newBook);

      Navigator.pop(
        context, newBook
      );
    } else {
      print("File not uploaded! Cannot add Book!");
    }
  }

  Future<void> uploadBook() async {
    result =
        await FilePicker.platform.pickFiles(allowMultiple: false); // error here

    /// logic to add the book to the shelf
    /// add the book to the books list
    print("File Selected: ${result!.files.single.name}");
  }

  void viewAllBooks(List<Book> books) {
    for (Book book in books) {
      print(
          "Title: ${book.title}, Author: ${book.author}, Added On: ${book.addedOn}, File Path: ${book.filePath}");
    }
  }

  Future<List<Book>> getBooksByShelf(String shelfId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'shelfId = ?',
      whereArgs: [shelfId],
    );

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        addedOn: maps[i]['addedOn'],
        filePath: maps[i]['filePath'],
        shelfId: maps[i]['shelfId']
      );
    });
  }
}
