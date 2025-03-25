import 'dart:io';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class shelfScreen extends StatefulWidget {
  final Shelf shelf;

  const shelfScreen({required this.shelf, Key? key}) : super(key: key);

  @override
  State<shelfScreen> createState() => _shelfScreenState();
}

class _shelfScreenState extends State<shelfScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  List<Book> books = [];
  List<Book> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
  }

  void _searchBooks() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      filteredBooks = books
          .where((book) => book.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addBook() async {
    /// show a dialog to add a new sheet
    final newBook = await showDialog<Book>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add a book"),
        content: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // name of the book field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Book title"),
            ),
            // name of the author field
            TextField(
              controller: _authorController,
              decoration: InputDecoration(hintText: "Author name"),
            ),
            /// upload the PDF file here
            MaterialButton(onPressed: () async {
                final FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false); // error here

                if (result == null) {
                  /// ask to re-upload the image before adding the book
                }
                else {
                  /// logic to add the book to the shelf
                  /// add the book to the books list
                }
              },
              child: Text('Upload a file'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _authorController.text.isNotEmpty) {
                /// Add logic to insert a book into the Shelf
                Navigator.pop(
                    context,
                    Book(
                        name: _nameController.text,
                        author: _authorController.text));
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void _deleteShelf() {
    /// Logic to remove
    /// Remove the shelf from the shared Prefs and remove the widget
    Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shelf.name),
        actions: [
          IconButton(onPressed: _deleteShelf, icon: Icon(Icons.delete))
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
                    onChanged: (_) => _searchBooks(),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                IconButton(onPressed: _searchBooks, icon: Icon(Icons.search)),
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
                            title: Text(filteredBooks[index].name),
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
        onPressed: _addBook,
        tooltip: "Add a Book",
        child: Icon(Icons.add),
      ),
    );
  }
}
