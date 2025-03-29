/// Represents a bookshelf category or genre.
/// 
/// Each shelf has a unique ID and a name that describes its category 
/// (e.g., Fiction, Science, History).
class Shelf {
  /// Unique identifier for the shelf.
  final String id;

  /// Name of the shelf (e.g., "Science Fiction", "History").
  final String name;

  /// Creates a new [Shelf] object with an ID and a name.
  /// 
  /// The [id] should be unique, and [name] represents the type of books 
  /// stored in this shelf.
  Shelf({required this.id, required this.name});

  /// Converts the [Shelf] object into a `Map<String, dynamic>` format.
  ///
  /// This is useful for storing shelf data in a SQLite database, where 
  /// each key-value pair corresponds to a column in the database table.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Creates a [Shelf] object from a map representation.
  ///
  /// This is used when retrieving shelf data from a SQLite database.
  /// The [map] parameter should contain keys matching the column names
  /// in the database table.
  factory Shelf.fromMap(Map<String, dynamic> map) {
    return Shelf(
      id: map['id'],
      name: map['name'],
    );
  }
}
