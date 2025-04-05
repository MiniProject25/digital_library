import 'package:digital_library/main.dart';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/screens/pdfViewerScreen.dart';
import 'package:digital_library/services/BookServices.dart';
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

class _bookDetailsScreenState extends State<bookDetailsScreen> with RouteAware {
  /// Service for handling book operations like delete
  bookServices bService = bookServices();

  /// current rating of the book
  int selectedRating = 0;

  /// Called when returning to this screen from another route.
  /// Used to refresh the rating display.
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    setState(() {
      widget.book.rating = selectedRating;
    });
  }

  /// Subscribes to the route observer to refresh state on navigation return.
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic>) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    routeObserver.unsubscribe(this);
  }

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
                    await bService.updateLastRead(widget.book.id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => pdfViewerScreen(
                          filePath: widget.book.filePath,
                          fileName: widget.book.title,
                        ),
                      ),
                    );
                  },
                  child: Text("Read"),
                ),

                /// Placeholder for rating functionality
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: Text("Rate this Book"),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final ratingValue = index + 1;
                                  final isSelected =
                                      selectedRating == ratingValue;

                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectedRating = ratingValue;
                                      });
                                      await bService.updateBookRating(
                                          widget.book.id, selectedRating);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.yellow
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Text(
                                        '$ratingValue',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.book.rating = selectedRating;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Save"))
                              ],
                            );
                          });
                        });
                  },
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
                    Text("Rating: ${widget.book.rating}",
                        style: TextStyle(fontSize: 16)),
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
