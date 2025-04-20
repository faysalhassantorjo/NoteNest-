import 'package:flutter/material.dart';

class NoteTakingPage extends StatefulWidget {
  @override
  _NoteTakingPageState createState() => _NoteTakingPageState();
}

class _NoteTakingPageState extends State<NoteTakingPage> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    _dayController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteNest'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save note functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildInputField('Topic Name:', _topicController),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('Day:', _dayController)),
                SizedBox(width: 16),
                Expanded(child: _buildInputField('Date:', _dateController)),
              ],
            ),
            SizedBox(height: 24),

            // Note Content Section
            Text(
              'A NoteNest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),

            // Topic Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTopicChip('Topic 1'),
                _buildTopicChip('Topic 2'),
                _buildTopicChip('Topic 3'),
                _buildTopicChip('Topic 4'),
                _buildTopicChip('Topic 5'),
              ],
            ),
            SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Source description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Picture Section
            Text(
              'Picture',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add_a_photo, size: 40),
                  onPressed: () {
                    // Add photo functionality
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            // Sortable Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '[Sortable]',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  '[2]',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildTopicChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.blue),
      ),
    );
  }
}
