import 'dart:io';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class databaseHelper {
  static final databaseHelper instance = databaseHelper._init(); // Singleton class
  static Database? _database;

  databaseHelper._init(); // private constructor

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDB('books.db');
    print("Database path: ${_database!.path}");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    print("Creating DB...");

    await db.execute("PRAGMA foreign_keys = ON;");

    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS shelves (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        );
      '''
    );
    
    await db.execute(
      '''
        CREATE TABLE IF NOT EXISTS books (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          addedOn TEXT NOT NULL,
          filePath TEXT NOT NULL,
          shelfId TEXT NOT NULL,
          FOREIGN KEY (shelfId) REFERENCES shelves(id) ON DELETE CASCADE
        );
      '''
    );


    print("Database tables created successfully.");
  }

  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<void> insertShelf(Shelf shelf) async {
    final db = await database;
    await db.insert('shelves', shelf.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteShelf(String shelfId) async {
    final db = await database;
    return db.delete('shelves', where: 'id = ?', whereArgs: [shelfId]);
  }

  Future<List<Shelf>> getAllShelves() async {
    final db = await database;
    final List<Map<String, dynamic>> shelfMaps = await db.query('shelves');

    return shelfMaps.map((map) => Shelf.fromMap(map)).toList();
  }

  /// check for db existence
  Future<bool> checkTableExists(String tableName) async {
    final db = await database;
    var result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'"
    );
    return result.isNotEmpty;
  }
}   