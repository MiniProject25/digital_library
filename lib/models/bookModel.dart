class Book {
  final String id;
  final String title;
  final String author;
  final String addedOn;
  final String filePath;
  final String shelfId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.addedOn,
    required this.filePath,
    required this.shelfId,
  });

  /// convert book object into map (to store in SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'addedOn': addedOn,
      'filePath': filePath,
      'shelfId': shelfId,
    };
  }

  /// Create a book object from map (for reading from SQLite)
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        addedOn: map['addedOn'],
        filePath: map['filePath'],
        shelfId: map['shelfId']);
  }
}
