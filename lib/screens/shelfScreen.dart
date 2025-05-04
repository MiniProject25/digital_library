import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/screens/bookDetailsScreen.dart';
import 'package:digital_library/themes/themes.dart';
import 'package:digital_library/widgets/bookTile.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/services/ShelfServices.dart';
import 'package:digital_library/services/BookServices.dart';
import 'addBookScreen.dart';

/// Displays the books in a specific shelf and allows searching, deleting,
/// and navigating to book details or adding new books.
class shelfScreen extends StatefulWidget {
  final Shelf shelf;

  const shelfScreen({required this.shelf, Key? key}) : super(key: key);

  @override
  State<shelfScreen> createState() => _shelfScreenState();
}

class _shelfScreenState extends State<shelfScreen> {
  /// Services for book and shelf operations
  final bookServices bService = bookServices();
  final shelfServices sService = shelfServices();

  /// Controllers for searching and adding books
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  /// Books currently in the shelf and the filtered list (after search)
  List<Book> books = [];
  List<Book> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks(); // Load books belonging to this shelf
    bService.viewAllBooks(books); // (optional) for general usage/debug
  }

  /// Updates filteredBooks with the result from a search
  void updateSearchResults(List<Book> results) {
    setState(() {
      filteredBooks = results;
    });
  }

  /// Called when a book is added to refresh the list
  void _onBookAdded(String shelfId) async {
    List<Book> updatedBooks = await bService.getBooksByShelf(shelfId);
    setState(() {
      books = updatedBooks;
      filteredBooks = books;
    });
  }

  /// Loads books from DB for the given shelf
  void _loadBooks() async {
    List<Book> loadedBooks = await bService.getBooksByShelf(widget.shelf.id);
    setState(() {
      books = loadedBooks;
      filteredBooks = books;
    });
  }

  /// Confirm delete dialog for shelf
  void _confirmDelete(String shelfId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
        backgroundColor: Colors.deepPurple.shade50,
        title: Text("Delete Shelf: ${widget.shelf.name}?"),
        content: Text("Are you sure you want to delete this shelf?"),
        contentTextStyle: TextStyle(fontFamily: 'OpenSans', color: Colors.black),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel"),),
          TextButton(
              onPressed: () async {
                await sService.deleteShelf(shelfId, context);
                Navigator.pop(context, true); // return true to pop screen
              },
              child: Text("Delete"),
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white
              )),
        ],
      ),
    );
  }

  /// Navigates to Book Details and reloads list if book gets deleted
  Future<void> _navigateToBook(Book book, BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => bookDetailsScreen(book: book)));

    if (result == true) {
      _loadBooks(); // Reload if book was removed
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorScheme.surface,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: purpleGradient
          ),
        ),
        title: Text(widget.shelf.name),
        titleTextStyle: textTheme.headlineLarge,
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
            /// Search bar with live updates
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a book',
                      hintStyle: TextStyle(color: Colors.deepPurple.shade200),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // suffixIcon: Icon(Icons.search, color: Colors.deepPurple,),
                    ),
                    onChanged: (_) => bService.searchBooks(
                        _searchController, updateSearchResults, books),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                    onPressed: () => bService.searchBooks(
                        _searchController, updateSearchResults, books),
                    icon: Icon(Icons.search)),
              ],
            ),
            SizedBox(height: 16),

            /// Book list or empty prompt
            Expanded(
              child: filteredBooks.isEmpty
                  ? Center(
                      child: Text(
                        "No books found!",
                        style: TextStyle(fontSize: 18, fontFamily: 'OpenSans', color: Colors.deepPurple.shade200, fontStyle: FontStyle.italic),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return BookTile(
                          book: book, 
                          onTap: () => _navigateToBook(book, context)
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      /// Button to add a new book using a dialog
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
        backgroundColor: Colors.deepPurple.shade100,
        tooltip: "Add a Book",
        child: Icon(Icons.add, color: Color.fromRGBO(94, 0, 159, 1),),
      ),
    );
  }
}
