import 'dart:io';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

/// Singleton class to manage all database operations for shelves and books.
class databaseHelper {
  static final databaseHelper instance = databaseHelper._init(); // Singleton instance
  static Database? _database;

  databaseHelper._init(); // Private constructor

  /// Getter to return the singleton database instance.
  /// Initializes the database if it's not already opened.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('books.db');
    return _database!;
  }

  /// Initializes the database by creating the file and tables if not present.
  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Creates the shelves and books tables with foreign key relationship.
  Future<void> _createDB(Database db, int version) async {
    print("Creating DB...");

    // Enable foreign key support for SQLite
    await db.execute("PRAGMA foreign_keys = ON;");

    // Table for shelves
    await db.execute('''
        CREATE TABLE IF NOT EXISTS shelves (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        );
      ''');

    // Table for books linked to shelves
    await db.execute('''
        CREATE TABLE IF NOT EXISTS books (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          addedOn TEXT NOT NULL,
          filePath TEXT NOT NULL,
          shelfId TEXT NOT NULL,
          lastRead INTEGER,
          rating INTEGER,
          FOREIGN KEY (shelfId) REFERENCES shelves(id) ON DELETE CASCADE
        );
      ''');

    print("Database tables created successfully.");
  }

  /// Inserts a new book into the database.
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  /// Deletes a book from the database by its ID.
  Future<int> deleteBook(String bookId) async {
    final db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [bookId]);
  }

  Future<int> deleteBookByShelf(String shelfId) async {
    final db = await database;
    return await db.delete('books', where: 'shelfId = ?', whereArgs: [shelfId]);
  }

  /// Inserts a shelf. If it already exists, replaces it.
  Future<void> insertShelf(Shelf shelf) async {
    final db = await database;
    await db.insert('shelves', shelf.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Deletes a shelf and all associated books due to foreign key cascade.
  Future<int> deleteShelf(String shelfId) async {
    final db = await database;
    return db.delete('shelves', where: 'id = ?', whereArgs: [shelfId]);
  }

  /// Checks if a table exists in the current database.
  Future<bool> checkTableExists(String tableName) async {
    final db = await database;
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return result.isNotEmpty;
  }

  /// Deletes the entire database file from the local storage.
  Future<void> deleteDatabaseFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dbPath = '${directory.path}/books.db';

      final file = File(dbPath);
      if (await file.exists()) {
        await file.delete();
        print("Database deleted successfully!");
      } else {
        print("Database file not found.");
      }
    } catch (e) {
      print("Error deleting database: $e");
    }
  }
}
