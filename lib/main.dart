import 'package:flutter/material.dart';
import 'package:notenest/channel_details.dart';

void main() {
  runApp(NoteNestApp());
}

class NoteNestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteNestHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.blueAccent),
          titleTextStyle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NoteNestHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<NoteNestHomePage> {
  int _selectedIndex = 0;
  String? selectedSemester;
  List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoteNest"),
        centerTitle: false,
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.blue),
            //   child: Center(
            //     child: Text("End Drawer"),
            //   ),
            // ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.car_crash),
              title: Text("Car"),
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("This is car")));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Batch Id / Channel Id',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.search, color: Colors.blueAccent),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),

            // Channel Cards Section
            Expanded(
              child: ListView(
                children: [
                  ChannelCard(
                      batch: "Batch 61",
                      semester: "7th",
                      dept: "Dept CSE",
                      unreadMessages: 5,
                      time: "10:30 AM"),
                  ChannelCard(
                      batch: "Batch 62",
                      semester: "5th",
                      dept: "Dept EEE",
                      unreadMessages: 2,
                      time: "09:15 AM"),
                  ChannelCard(
                      batch: "Batch 63",
                      semester: "4th",
                      dept: "Dept EEE",
                      unreadMessages: 2,
                      time: "09:15 AM"),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, size: 28),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
      ),

      // Modern Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChannelCard extends StatelessWidget {
  final String batch;
  final String semester;
  final String dept;
  final int unreadMessages;
  final String time;

  ChannelCard({
    required this.batch,
    required this.semester,
    required this.dept,
    required this.unreadMessages,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: InkWell(
        onTap: () {
          // Navigate to SecondPage when tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChannelDetailsPage()),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // Leading Icon/Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.blueAccent.withOpacity(0.2),
                    child:
                        Icon(Icons.school, color: Colors.blueAccent, size: 30),
                  ),
                ),
                SizedBox(width: 16),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        batch,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(semester,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      SizedBox(height: 4),
                      Text(dept,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),

                // Trailing Unread Messages and Time
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (unreadMessages > 0)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.blueAccent,
                        child: Text('$unreadMessages',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    SizedBox(height: 4),
                    Text(time,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
