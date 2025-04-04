import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/screens/pdfViewerScreen.dart';
import 'package:digital_library/services/BookServices.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a selected [Book].
///
/// Allows the user to read the book, rate it (future implementation),
/// or delete it from the library. Also shows basic metadata like author name.
class bookDetailsScreen extends StatefulWidget {
  final Book book;

  const bookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<bookDetailsScreen> createState() => _bookDetailsScreenState();
}

class _bookDetailsScreenState extends State<bookDetailsScreen> {
  /// Service for handling book operations like delete
  bookServices bService = bookServices();

  /// Book rating (feature placeholder)
  int rating = 0;

  /// Shows a confirmation dialog before deleting the book.
  void _confirmDelete(String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Book: ${widget.book.title}?"),
        content: Text("Are you sure you want to delete the book?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await bService.deleteBook(bookId, context);
              // ignore: use_build_context_synchronously
              Navigator.pop(context, true); // Close the confirmation dialog
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action buttons: Read, Rate (future), Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Opens PDF viewer and updates last read timestamp
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => pdfViewerScreen(
                          filePath: widget.book.filePath,
                          fileName: widget.book.title,
                        ),
                      ),
                    );

                    await bService.updateLastRead(widget.book.id);
                  },
                  child: Text("Read"),
                ),

                /// Placeholder for rating functionality
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Rate"),
                ),

                /// Deletes the book after confirmation
                ElevatedButton(
                  onPressed: () => _confirmDelete(widget.book.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  child: Text("Delete"),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// Book info card (metadata placeholder)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Author: ${widget.book.author}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text("No. of Pages: --", style: TextStyle(fontSize: 16)),
                    Text("Pages Read: --", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
