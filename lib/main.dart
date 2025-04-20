import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notenest/channel_details.dart';
import 'package:notenest/create_channel.dart';
import 'package:notenest/feed.dart';
import 'package:notenest/login_page.dart';
import 'package:notenest/notenestpage.dart';
import 'package:notenest/notetakingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NoteNestHomePage extends StatefulWidget {
  @override
  State<NoteNestHomePage> createState() => _NoteNestHomePageState();
}

class _NoteNestHomePageState extends State<NoteNestHomePage> {
  int _selectedIndex = 0;
  final Stream<QuerySnapshot> _channelStream =
      FirebaseFirestore.instance.collection('Channels').snapshots();

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SocialFeedPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String userName = 'Guest';
    String userEmail = 'Not logged in';

    if (user != null) {
      userName = user.displayName ?? '';
      userEmail = user.email ?? 'No email';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NoteNest"),
        centerTitle: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.person, color: Colors.black),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(userName, userEmail, user),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 12),
            Expanded(child: _buildChannelList()),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => NoteTakingPage()),
      //       );
      //     },
      //     child: Icon(Icons.add, size: 28),
      //     backgroundColor: Colors.blue,
      //     elevation: 2,
      //     tooltip: "Create Post"),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDrawer(String userName, String userEmail, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName, style: TextStyle(fontSize: 18)),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/1.jpg'),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: Colors.blue),
            title: Text('Create Channel', style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FormPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined, color: Colors.blue),
            title: Text('Settings', style: TextStyle(fontSize: 16)),
            onTap: () {
              // Handle settings
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              user == null ? Icons.login : Icons.logout,
              color: Colors.blue,
            ),
            title: Text(
              user == null ? 'Login' : 'Logout',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () async {
              if (user == null) {
                // Navigate to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } else {
                // Logout the user
                await FirebaseAuth.instance.signOut();

                // Optional: Navigate to home or login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search channels...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildChannelList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _channelStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading channels'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final channels = snapshot.data!.docs;

        if (channels.isEmpty) {
          return Center(child: Text('No channels found'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: channels.length,
          itemBuilder: (context, index) {
            final channel = channels[index].data() as Map<String, dynamic>;
            return _buildChannel(
              batch: channel['batch']?.toString() ?? 'No Batch',
              semester: channel['semester']?.toString() ?? 'No Semester',
              dept: channel['dept']?.toString() ?? 'No Department',
              available_course:
                  (channel['available_course'] as num?)?.toInt() ?? 0,
              time: channel['time']?.toString() ?? '01:51',
              channelId: channels[index].id,
            );
          },
        );
      },
    );
  }

  Widget _buildChannel({
    required String batch,
    required String semester,
    required String dept,
    required int available_course,
    required String time,
    required String channelId,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 109, 109, 109).withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChannelDetailsPage(channelId: channelId),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(channelId),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      batch.isNotEmpty ? batch[0] : 'N',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // Channel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Batch $batch",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Text(
                          //   time,
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 4),

                      // Subtitle
                      Text(
                        "${semester}th • $dept",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEF0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          size: 16, color: Color(0xFF6E8AFA)),
                      SizedBox(width: 4),
                      Text(
                        '$available_course Courses',
                        style: TextStyle(
                          color: Color(0xFF6E8AFA),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String id) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    final index = id.hashCode % colors.length;
    return colors[index];
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.live_help),
          activeIcon: Icon(Icons.live_help),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          activeIcon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }
}
