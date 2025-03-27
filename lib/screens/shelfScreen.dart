import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
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
    setState(() {
      filteredBooks = books;
    });
    bService.viewAllBooks(books);
  }

  void updateSearchResults(List<Book> results) {
    setState(() {
      filteredBooks = results;
    });
  }

  void _onBookAdded(String title, String author, String filePath, String shelfId) {
    setState(() {
      books.add(Book(
          id: bService.uuid.v1(),
          title: title,
          author: author,
          addedOn: DateTime.now(),
          filePath: filePath,
          shelfId: shelfId));
      filteredBooks = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shelf.name),
        actions: [
          IconButton(
              onPressed: () => sService.deleteShelf(context),
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
          final Book? newBook = await showDialog<Book>(
              context: context,
              builder: (BuildContext context) {
                return addBookScreen(
                    nameController: _nameController,
                    authorController: _authorController,
                    onBookAdded: _onBookAdded);
              });

          if (newBook != null) {
            _onBookAdded(newBook.title, newBook.author, newBook.filePath);
          }
        },
        tooltip: "Add a Book",
        child: Icon(Icons.add),
      ),
    );
  }
}
