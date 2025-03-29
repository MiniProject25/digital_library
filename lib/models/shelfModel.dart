class Shelf {
  /// type of shelf; representing a genre;
  final String id;
  final String name;

  Shelf({required this.id, required this.name});

  /// convert shelf into a map (for inserting into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// create shelf object from a map (for reading from SQLite)
  factory Shelf.fromMap(Map<String, dynamic> map) {
    return Shelf(
      id: map['id'],
      name: map['name']
    );
  }
}
