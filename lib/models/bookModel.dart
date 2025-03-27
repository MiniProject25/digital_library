class Book {
  final String id;
  final String title;
  final String author;
  final DateTime addedOn;
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
}