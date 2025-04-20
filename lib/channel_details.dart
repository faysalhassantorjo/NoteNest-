import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notenest/notenestpage.dart';

class ChannelDetailsPage extends StatefulWidget {
  final String channelId;

  const ChannelDetailsPage({Key? key, required this.channelId})
      : super(key: key);

  @override
  _ChannelDetailsPageState createState() => _ChannelDetailsPageState();
}

class _ChannelDetailsPageState extends State<ChannelDetailsPage> {
  List<Map<String, dynamic>> courses = [];
  bool isLoading = false;
  String selectedSemester = '7th Sem';
  Map<String, dynamic> channelData = {};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChannelDetails();
    fetchCourses();
  }

  Future<void> fetchChannelDetails() async {
    try {
      DocumentSnapshot channelDoc = await FirebaseFirestore.instance
          .collection('Channels')
          .doc(widget.channelId)
          .get();

      if (channelDoc.exists) {
        setState(() {
          channelData = channelDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching channel details: $e');
    }
  }

  Future<void> fetchCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final courseData = await getCoursesByChannel();
      setState(() {
        courses = courseData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching courses: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCoursesByChannel() async {
    try {
      DocumentReference channelRef = FirebaseFirestore.instance
          .collection('Channels')
          .doc(widget.channelId);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Course')
          .where('channel', isEqualTo: channelRef)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<void> _addCourse() async {
    if (_formKey.currentState!.validate()) {
      try {
        DocumentReference channelRef = FirebaseFirestore.instance
            .collection('Channels')
            .doc(widget.channelId);

        await FirebaseFirestore.instance.collection('Course').add({
          'name': _courseNameController.text,
          'code': _courseCodeController.text,
          'channel': channelRef,
          'semester': selectedSemester,
          'noteCount': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection('Channels')
            .doc(widget.channelId)
            .update({'available_course': FieldValue.increment(1)});

        // Clear form and refresh courses
        _courseNameController.clear();
        _courseCodeController.clear();
        fetchCourses();
        Navigator.of(context).pop(); // Close the dialog
      } catch (e) {
        print('Error adding course: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add course: $e')),
        );
      }
    }
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Course'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _courseNameController,
                    decoration: InputDecoration(labelText: 'Course Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter course name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _courseCodeController,
                    decoration: InputDecoration(labelText: 'Course Code'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter course code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSemester,
                    items: [
                      DropdownMenuItem(
                        value: '6th Sem',
                        child: Text('6th Semester'),
                      ),
                      DropdownMenuItem(
                        value: '7th Sem',
                        child: Text('7th Semester'),
                      ),
                      DropdownMenuItem(
                        value: '8th Sem',
                        child: Text('8th Semester'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSemester = value;
                        });
                      }
                    },
                    decoration: InputDecoration(labelText: 'Semester'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addCourse,
              child: Text('Add Course'),
            ),
          ],
        );
      },
    );
  }

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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddCourseDialog,
            tooltip: 'Add Course',
          ),
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Channel Information Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Channel ID: ${widget.channelId}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      channelData['name'] ?? 'Channel Name',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label:
                              Text(channelData['department'] ?? 'Department'),
                          backgroundColor: Colors.blue[50],
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text(channelData['batch'] ?? 'Batch'),
                          backgroundColor: Colors.green[50],
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text(selectedSemester),
                          backgroundColor: Colors.orange[50],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Courses Section
            Text(
              'Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            isLoading
                ? Center(child: CircularProgressIndicator())
                : courses.isEmpty
                    ? Center(
                        child: Text('No courses found',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : Column(
                        children: courses
                            .map((course) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: CourseCard(course: course),
                                ))
                            .toList(),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Course',
      ),
    );
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    super.dispose();
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

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
            MaterialPageRoute(
              builder: (context) => NotePage(courseId: course['id']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course['name'] ?? 'Course Name',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Chip(
                    label: Text(course['semester'] ?? 'Semester'),
                    backgroundColor: Colors.orange[50],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                course['code'] ?? 'Course Code',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Notes: ${course['noteCount'] ?? 0}',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    'Created: ${_formatDate(course['createdAt'])}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}';
    }
    return 'N/A';
  }
}
