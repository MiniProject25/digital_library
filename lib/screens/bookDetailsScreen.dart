import 'package:digital_library/main.dart';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/screens/pdfViewerScreen.dart';
import 'package:digital_library/services/BookServices.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:digital_library/themes/themes.dart';
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

  /// last read page
  int lastReadPage = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateLastReadPage();
  }

  /// Called when returning to this screen from another route.
  /// Used to refresh the rating display.
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    fetchLastReadPage();
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

  /// to update the last read page
  void _updateLastReadPage() {
    setState(() {
      lastReadPage = widget.book.lastReadPage;
    });
  }

  /// fetch the last read page as it gets updated in the db
  Future<void> fetchLastReadPage() async {
    final page = await bService.getLastReadPage(widget.book.id);
    setState(() {
      lastReadPage = page;
    });
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
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 25
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: purpleGradient
          ),
        ),
        title: Text(widget.book.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
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
                          currentPage: lastReadPage,
                          book: widget.book,
                          filePath: widget.book.filePath,
                          fileName: widget.book.title,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade500,
                    foregroundColor: Colors.white
                  ),
                  child: Text("Read", style: TextStyle(fontFamily: 'OpenSans'),),
                ),

                /// Placeholder for rating functionality
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade500,
                    foregroundColor: Colors.white
                  ),
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
                  child: Text("Rate", style: TextStyle(fontFamily: 'OpenSans'),),
                ),

                /// Deletes the book after confirmation
                ElevatedButton(
                  onPressed: () => _confirmDelete(widget.book.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white
                  ),
                  child: Text("Delete", style: TextStyle(fontFamily: 'OpenSans'),),
                ),
              ],
            ),

            SizedBox(height: 20),

            /// Book info card (metadata placeholder)
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.deepPurple.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Author: ${widget.book.author}",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500, 
                            color: Colors.deepPurple.shade900,),
                        ),
                        SizedBox(height: 15),
                        Text("Last Page Read: $lastReadPage", style: TextStyle(
                          fontSize: 18, 
                          fontFamily: 'OpenSans', 
                          fontWeight: FontWeight.w500, 
                          color: Colors.deepPurple.shade900,)),
                        SizedBox(height: 12),
                        Text("Pages Read: --", style: TextStyle(
                          fontSize: 18, 
                          fontFamily: 'OpenSans', 
                          fontWeight: FontWeight.w500, 
                          color: Colors.deepPurple.shade900,)),
                        SizedBox(height: 10),
                        Text("Rating: ${widget.book.rating}",
                            style: TextStyle(
                              fontSize: 18, 
                              fontFamily: 'OpenSans', 
                              fontWeight: FontWeight.w500, 
                              color: Colors.deepPurple.shade900,)),
                      ],
                    ),
                  ),
                ),
              ),
            ),   
          ],
        ),
      ),
    );
  }
}
