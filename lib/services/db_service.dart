import 'dart:io';
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
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE books (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          addedOn TEXT NOT NULL,
          filePath TEXT NOT NULL,
          sheldId TEXT NOT NULL,
          FOREIGN KEY (shelfId) REFERENCES shelves(id) ON DELETE CASCADE
        )

        CREATE TABLE shelves (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        )
      '''
    );
  }
}   