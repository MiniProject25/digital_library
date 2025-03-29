import 'package:digital_library/models/shelfModel.dart';
import 'package:digital_library/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:digital_library/widgets/shelfCard.dart';

/// The main screen of the digital library.
/// Displays user's shelves and recently read books.
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  /// List to store the user's shelves
  List<Shelf> shelves = [];

  @override
  void initState() {
    super.initState();
    // Place for initializing data or loading persisted shelves later
    _loadShelves();
  }

  void _loadShelves() async {
    bool doesShelfExist =
        await databaseHelper.instance.checkTableExists('shelves');
    if (doesShelfExist) {
      List<Shelf> shelves = await databaseHelper.instance.getAllShelves();
      setState(() {
        this.shelves = shelves;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App bar with custom style
      appBar: AppBar(
        title: Text("Welcome to your Digital Library!"),
        backgroundColor: Color.fromARGB(0, 255, 16, 240), // Transparent color
        titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0),
          fontSize: 25,
          fontFamily: 'Lucida',
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),

      /// Right-side drawer for future settings or personalization
      endDrawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Drawer Header")),
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
          ],
        ),
      ),

      /// Main screen body layout
      body: Column(
        children: [
          /// Section: Shelf list or prompt to create shelves
          SizedBox(
            height: 300,
            child: shelves.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Shelves yet!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Tap + to add one.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),

                      /// Add shelf button (shown only when no shelves exist)
                      ElevatedButton(
                        onPressed: () async {
                          // Navigate to addShelf screen and wait for result
                          final newShelf =
                              await Navigator.pushNamed(context, '/addShelf');

                          // If a shelf was created, add it to the list
                          if (newShelf != null) {
                            final fetchedShelves =
                                await databaseHelper.instance.getAllShelves();
                            setState(() {
                              shelves = fetchedShelves;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.blueAccent,
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
                      /// To display Existing shelves
                      if (index < shelves.length) {
                        return shelfCard(
                            title: shelves[index].name,
                            onTap: () {
                              Navigator.pushNamed(context, '/shelfScreen',
                                  arguments: shelves[index]);
                            });
                      }

                      /// Adding the + Icon Card to add more shelves
                      else {
                        return shelfCard(
                          title: "Add a Shelf",
                          onTap: () async {
                            // Navigate to addShelf screen and wait for result
                            final newShelf =
                                await Navigator.pushNamed(context, '/addShelf');
                            // If a shelf was created, add it to the list
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

          const SizedBox(height: 20),

          /// Section: Recently Read Books
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.amber,
              margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for recently read books or book cards
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
