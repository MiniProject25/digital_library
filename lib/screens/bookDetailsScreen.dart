import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/services/BookServices.dart';
import 'package:flutter/material.dart';

class bookDetailsScreen extends StatefulWidget {
  final Book book;

  const bookDetailsScreen({Key? key, required this.book})
      : super(key: key);

  @override
  State<bookDetailsScreen> createState() => _bookDetailsScreenState();
}

class _bookDetailsScreenState extends State<bookDetailsScreen> {
  bookServices bService = bookServices();
  int rating = 0; 

  void _confirmDelete(String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Delete Book: ${widget.book.title}?"),
        content: Text("Are you sure you want to delete the book?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
              onPressed: () async {
                await bService.deleteBook(bookId, context);
                // ignore: use_build_context_synchronously
                Navigator.pop(context, true); // pop the alert
              },
              child: Text("Delete")),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Read")),
                ElevatedButton(onPressed: () {}, child: Text("Rate")),
                ElevatedButton(
                  onPressed: () => _confirmDelete(widget.book.id),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, textStyle: TextStyle(color: Colors.white)),
                  child: Text("Delete")
                ),
              ],
            ),

            SizedBox(height: 20,),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Author: ${widget.book.author}", style: TextStyle(fontSize: 16),),
                    SizedBox(height: 10,),
                    Text("No. of Pages: --", style: TextStyle(fontSize: 16),),
                    Text("Pages Read: --", style: TextStyle(fontSize: 16),),
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
