/// Represents a book in the bookshelf system.
/// 
/// This class is used to store and retrieve book details in SQLite.
/// Each book has an ID, title, author, date it was added, file path, 
/// and the ID of the shelf it belongs to.
class Book {
  /// Unique identifier for the book.
  final String id;

  /// Title of the book.
  final String title;

  /// Name of the book's author.
  final String author;

  /// Date when the book was added to the shelf.
  final String addedOn;

  /// Local file path of the book (e.g., a PDF file stored on the device).
  final String filePath;

  /// ID of the shelf to which this book belongs.
  final String shelfId;

  /// timestamp in milliseconds of the last time the book was read.
  int lastRead;

  /// integer that denotes the rating of the book (out of 5)
  int rating;

  /// Creates a new [Book] object with the required details.
  ///
  /// The [id] should be unique, [title] and [author] provide book details,
  /// [addedOn] stores the date of addition, [filePath] holds the file location,
  /// and [shelfId] associates the book with a specific shelf.
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.addedOn,
    required this.filePath,
    required this.shelfId,
    required this.lastRead,
    required this.rating,
  });

  /// Converts the [Book] object into a `Map<String, dynamic>` format.
  ///
  /// This is useful when storing book data in a SQLite database,
  /// where each key-value pair represents a column in the table.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'addedOn': addedOn,
      'filePath': filePath,
      'shelfId': shelfId,
      'lastRead': lastRead,
      'rating': rating,
    };
  }

  /// Creates a [Book] object from a map representation.
  ///
  /// This is used when retrieving book data from a SQLite database.
  /// The [map] parameter should contain keys matching the column names
  /// in the database table.
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      addedOn: map['addedOn'],
      filePath: map['filePath'],
      shelfId: map['shelfId'],
      lastRead: map['lastRead'],
      rating: map['rating'],
    );
  }
}
