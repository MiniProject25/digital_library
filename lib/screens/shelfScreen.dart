import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/screens/bookDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/services/ShelfServices.dart';
import 'package:digital_library/services/BookServices.dart';
import 'addBookScreen.dart';

class shelfScreen extends StatefulWidget {
  final Shelf shelf;

  const shelfScreen({required this.shelf, Key? key}) : super(key: key);

  @override
  State<shelfScreen> createState() => _shelfScreenState();
}

class _shelfScreenState extends State<shelfScreen> {
  /// services
  final bookServices bService = bookServices();
  final shelfServices sService = shelfServices();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  List<Book> books = [];
  List<Book> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();

    /// loads up the books list
    bService.viewAllBooks(books);
  }

  void updateSearchResults(List<Book> results) {
    setState(() {
      filteredBooks = results;
    });
  }

  void _onBookAdded(String shelfId) async {
    List<Book> updatedBooks = await bService.getBooksByShelf(shelfId);
    setState(() {
      books = updatedBooks;
      filteredBooks = books;
    });
  }

  /// to run at the beginning (when entering the Shelf Screen)
  void _loadBooks() async {
    List<Book> loadedBooks = await bService.getBooksByShelf(widget.shelf.id);
    setState(() {
      books = loadedBooks;
      filteredBooks = books;
    });
  }

  void _confirmDelete(String shelfId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Shelf: ${widget.shelf.name}?"),
        content: Text("Are you sure you want to delete the shelf?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
              onPressed: () async {
                await sService.deleteShelf(shelfId, context);
                // ignore: use_build_context_synchronously
                Navigator.pop(context, true);
              },
              child: Text("Delete")),
        ],
      ),
    );
  }

  Future<void> _navigateToBook(Book book, BuildContext context) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => bookDetailsScreen(book: book))
    );

    // ignore: unrelated_type_equality_checks
    if (result == true) {
      _loadBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shelf.name),
        actions: [
          IconButton(
              onPressed: () => _confirmDelete(widget.shelf.id),
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a book',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (_) => bService.searchBooks(
                        _searchController, updateSearchResults, books),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                IconButton(
                    onPressed: () => bService.searchBooks(
                        _searchController, updateSearchResults, books),
                    icon: Icon(Icons.search)),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: filteredBooks.isEmpty
                  ? Center(
                      child: Text(
                        "No books found!",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(filteredBooks[index].title),
                            subtitle: Text(filteredBooks[index].author),
                            onTap: () => _navigateToBook(filteredBooks[index], context),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      /// Button to add a book
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBook = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return addBookScreen(
                  nameController: _nameController,
                  authorController: _authorController,
                  onBookAdded: _onBookAdded,
                  shelfId: widget.shelf.id,
                );
              });

          if (newBook != null) {
            _onBookAdded(newBook.shelfId);
          }
        },
        tooltip: "Add a Book",
        child: Icon(Icons.add),
      ),
    );
  }
}
