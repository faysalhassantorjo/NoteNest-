import 'package:flutter/material.dart';
import 'package:notenest/notenestpage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChannelDetailsPage(),
  ));
}

class ChannelDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteNest',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Channel Name',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text('Batch C1',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            Text('Dept CSE',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 20),
            _buildSemesterDropdown(),
            SizedBox(height: 20),
            CourseCard(),
            SizedBox(height: 16),
            CourseCard(),
            SizedBox(height: 16),
            CourseCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: '7th Sem',
        items: [
          DropdownMenuItem(
              value: '7th Sem',
              child: Text('7th Sem', style: TextStyle(fontSize: 16))),
        ],
        onChanged: (value) {},
        underline: SizedBox(), // Remove the default underline
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
        isExpanded: true,
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotePage()),
          );
        },
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Name',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'CSE 234',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Available Notes: 20',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage('assets/images/1.jpg'),
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage('assets/images/2.jpg'),
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage('assets/images/3.jpg'),
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: AssetImage('assets/images/5.jpg'),
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                "5+",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 7, 114, 255),
                                ),
                              ),
                            )),
                      ],
                    ),
                    Text(
                      '08/03/2025',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class NoteNestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteNest', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text('NoteNest Page'),
      ),
    );
  }
}
