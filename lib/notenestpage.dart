import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NoteNest',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Batch and Course Info
          Text(
            'Batch C1',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(height: 4),
          Text(
            'Course Name',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(
            '20 Threads Available',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          // Note Threads
          _buildNoteThread(
            authorName: 'Faysal Hassan',
            time: '23:49  17/2/25',
            reactors: ['User1', 'User2', 'User3'],
            description:
                'This is a detailed description of the course content.',
            files: ['file1', 'file2', 'file3', 'file4'],
            tutorialLinks: ['link1', 'link2', 'link3', 'link4'],
          ),
          SizedBox(height: 16),
          _buildNoteThread(
            authorName: 'John Doe',
            time: '12:30  18/2/25',
            reactors: ['User4', 'User5'],
            description: 'Another example of a note thread.',
            files: ['fileA', 'fileB'],
            tutorialLinks: ['linkA', 'linkB'],
          ),
          // Add more threads as needed
        ],
      ),
    );
  }

  Widget _buildNoteThread({
    required String authorName,
    required String time,
    required List<String> reactors,
    required String description,
    required List<String> files,
    required List<String> tutorialLinks,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          time,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.thumb_up, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 8),

            // Reactors
            Text(
              'Reacted by: ${reactors.join(', ')}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            // Files Section
            Text(
              'Files',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: files
                  .map((file) => Chip(
                        label: Text(file),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        avatar: Icon(Icons.insert_drive_file,
                            size: 18, color: Colors.blue),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),

            // Tutorial Links Section
            Text(
              'Tutorial Links',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: tutorialLinks
                  .map((link) => ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.link, size: 16, color: Colors.white),
                        label: Text(
                          link,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
