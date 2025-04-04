import 'dart:io';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:digital_library/widgets/customSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

/// Service class to manage operations related to books such as
/// adding, deleting, uploading, and retrieving books from a shelf.
class bookServices {
  final uuid = Uuid();
  final databaseHelper _dbHelper = databaseHelper.instance;
  FilePickerResult? result;

  /// Filters the given list of books based on the search query in [searchController],
  /// and returns the result via [onSearchResult].
  void searchBooks(TextEditingController searchController,
      Function(List<Book>) onSearchResult, List<Book> books) {
    final query = searchController.text.trim().toLowerCase();

    List<Book> results = books
        .where((book) => book.title.toLowerCase().contains(query))
        .toList();

    onSearchResult(results);
  }

  /// Uploads a file using [FilePicker] and validates it as a PDF or EPUB.
  /// Shows a [SnackBar] to indicate success or failure.
  Future<void> uploadBook(BuildContext context) async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );

    if (result != null) {
      File file = File(result!.files.single.path!);
      String extension = file.path.split('.').last.toLowerCase();

      if (extension != 'pdf' && extension != 'epub') {
        Customsnackbar.show(context, "Only PDF and EPUB files are allowed", false);
        return;
      }

      Customsnackbar.show(context, "File Selected Successfully!", true);
    } else {
      Customsnackbar.show(context, "File selection canceled.", false);
    }

    print("File Selected: ${result?.files.single.name}");
  }

  /// Adds a new book to the local database and links it to a shelf using [shelfId].
  /// Requires book title, author, and selected file.
  /// On success, it pops the navigation stack and returns the new book object.
  Future<void> addBook(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController authorController,
    String shelfId,
  ) async {
    if (nameController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        result != null) {
      DateTime date = DateTime.now();

      Book newBook = Book(
        id: uuid.v1(),
        title: nameController.text,
        author: authorController.text,
        addedOn: DateTime(date.year, date.month, date.day).toString(),
        filePath: result!.files.single.path ?? '',
        shelfId: shelfId,
        lastRead: 0,
      );

      await _dbHelper.insertBook(newBook);

      Navigator.pop(context, newBook);
      result = null; // Clear after use
    } else {
      Customsnackbar.show(context, "Please fill all fields and select a file.", false);
    }
  }

  /// Deletes a book from the database by its [bookId].
  /// Pops the current screen after deletion.
  Future<void> deleteBook(String bookId, BuildContext context) async {
    await databaseHelper.instance.deleteBook(bookId);
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  /// Prints all book details in the provided [books] list to the console.
  void viewAllBooks(List<Book> books) {
    for (Book book in books) {
      print(
          "Title: ${book.title}, Author: ${book.author}, Added On: ${book.addedOn}, File Path: ${book.filePath}");
    }
  }

  /// Retrieves all books associated with the given [shelfId] from the database.
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
        shelfId: maps[i]['shelfId'],
        lastRead: maps[i]['lastRead'],
      );
    });
  }

  /// Retrieves the most recently read books (based on the `lastRead` timestamp).
  /// Limited to top 5 results.
  Future<List<Book>> getRecentlyReadBooks() async {
    final db = await databaseHelper.instance.database;
    final result = await db.query('books', orderBy: 'lastRead DESC', limit: 5);

    return result.map((e) => Book.fromMap(e)).toList();
  }

  /// Updates the lastRead timestamp of a book to current time.
  Future<void> updateLastRead(String bookId) async {
    final db = await databaseHelper.instance.database;
    await db.update(
        'books', {'lastRead': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?', whereArgs: [bookId]);
  }
}
