import 'package:digital_library/main.dart';
import 'package:digital_library/models/bookModel.dart';
import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/screens/addShelfScreen.dart';
import 'package:digital_library/screens/bookDetailsScreen.dart';
import 'package:digital_library/screens/shelfScreen.dart';
import 'package:digital_library/services/BookServices.dart';
import 'package:digital_library/services/ShelfServices.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/widgets/shelfCard.dart';

/// The main screen of the digital library.
/// Displays the user's shelves and recently read books.
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with RouteAware {
  /// List to store the user's shelves
  List<Shelf> shelves = [];

  /// List to store recently read books
  List<Book> recentlyRead = [];

  /// Service to handle book-related operations
  bookServices bService = bookServices();

  /// Service to handle shelf-related operations
  shelfServices sService = shelfServices();

  @override
  void initState() {
    super.initState();
    _loadShelves();
    _loadRecentlyRead();
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    super.didPopNext();
    _loadRecentlyRead();
  }

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
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Loads all the shelves from the database (if table exists)
  void _loadShelves() async {
    bool doesShelfExist =
        await databaseHelper.instance.checkTableExists('shelves');
    if (doesShelfExist) {
      List<Shelf> shelves = await sService.getAllShelves();
      setState(() {
        this.shelves = shelves;
      });
    }
  }

  /// Loads the list of books that were recently read
  void _loadRecentlyRead() async {
    List<Book> recent = await bService.getRecentlyReadBooks();
    setState(() {
      recentlyRead = recent;
    });
  }

  /// Navigates to a shelf screen and reloads shelves if any changes occur
  Future<void> _navigateToShelf(Shelf shelf, BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => shelfScreen(shelf: shelf)));

    /// If shelf was deleted or modified
    if (result == true) {
      _loadShelves();
      _loadRecentlyRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(137, 157, 239, 1),
      /// App bar with a welcoming message
      appBar: AppBar(
        title: Text("Welcome to ReadSpace!"),
        backgroundColor: Color.fromRGBO(94, 0, 159, 1),
        titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 25,
            fontFamily: 'Poppins',
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,),
        centerTitle: false,
        toolbarHeight: 100,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),

      /// Drawer for future settings or advanced options
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Digital Reader")),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                print("Clicked 1!");
              },
            ),
            ListTile(
              title: const Text("About"),
              onTap: () {
                print("Clicked 2!");
              },
            ),
            ListTile(
              title: Text("Delete DB"),
              onTap: () => databaseHelper.instance.deleteDatabaseFile(),
            )
          ],
        ),
      ),

      /// Main UI section showing shelves and recently read books
      body: Column(
        children: [
          /// Horizontal list of shelves or message to create a shelf
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 26),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(94, 0, 159, 1),
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              height: 300,
              child: shelves.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Shelves yet!",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Tap + to add one.",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),

                        /// Circular "+" button to create new shelf
                        ElevatedButton(
                          onPressed: () async {
                            final newShelf = await showDialog(
                                context: context,
                                builder: (context) {
                                  return addShelfScreen();
                                });

                            if (newShelf != null) {
                              final fetchedShelves =
                                  await sService.getAllShelves();
                              setState(() {
                                shelves = fetchedShelves;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: EdgeInsets.all(18),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: shelves.length + 1,
                      itemBuilder: (context, index) {
                        /// Show existing shelves
                        if (index < shelves.length) {
                          return shelfCard(
                            title: shelves[index].name,
                            onTap: () {
                              _navigateToShelf(shelves[index], context);
                            },
                          );
                        }

                        /// Show '+' card to add a new shelf
                        else {
                          return shelfCard(
                            title: "Add a Shelf",
                            onTap: () async {
                              final newShelf = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return addShelfScreen();
                                  });
                              if (newShelf != null) {
                                setState(() {
                                  shelves.add(newShelf as Shelf);
                                });
                              }
                            },
                          );
                        }
                      },
                    ),
            ),
          ),

          const SizedBox(height: 8),

          /// Vertical list of recently read books
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Color.fromRGBO(94, 0, 159, 1),
              ),
              width: MediaQuery.of(context).size.width,   
              margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            
              /// Display message if list is empty
              child: recentlyRead.isEmpty
                  ? Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book, color: Colors.white,),
                        Text(
                          "No recently read books",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'OpenSans',),
                          
                        ),
                      ],
                    ))
                  : ListView.builder(
                      itemCount: recentlyRead.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          title: Text(recentlyRead[index].title),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  bookDetailsScreen(book: recentlyRead[index]),
                            ),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await bService.updateLastReadToZero(
                                    recentlyRead[index].id);
                                _loadRecentlyRead();
                              }),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
