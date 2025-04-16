import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @overridegit
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _createdAt;
  String? _selectedBatch;
  String? _selectedSemester;
  String? _selectedDept;

  CollectionReference channels =
      FirebaseFirestore.instance.collection('Channels');

  Future<void> create_channel() {
    return channels.add({
      'batch': _selectedBatch,
      'semester': _selectedSemester,
      'dept': _selectedDept
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text('Channel Created!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Some Error Occured: $error')));
    });

    // print('channel Created');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.indigo,
    //     content: Text(
    //       'Form submitted by ${currentUser?.email ?? 'Unknown user'}\n'
    //       'Batch: $_selectedBatch | Semester: $_selectedSemester\n'
    //       'Department: $_selectedDept',
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //   ),
    // );
  }

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DateTime currentTime = DateTime.now();

  final List<String> batches = ['66', '65', '64', '63', '62', '61', '60'];
  final List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  final List<String> departments = [
    'CSE',
    'EEE',
    'Mechanical',
    'Civil',
    'Electronics'
  ];

  @override
  Widget build(BuildContext context) {
    final displayDate = _createdAt ?? currentTime;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Batch',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            value: _selectedBatch,
                            items: batches.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBatch = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a batch';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Semester',
                              prefixIcon: Icon(Icons.format_list_numbered),
                            ),
                            value: _selectedSemester,
                            items: semesters.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('Semester $value'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSemester = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a semester';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Department',
                              prefixIcon: Icon(Icons.school),
                            ),
                            value: _selectedDept,
                            items: departments.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDept = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a department';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.indigo),
                      title: const Text('Created By'),
                      subtitle: Text(currentUser?.email ?? 'Not logged in',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading:
                          const Icon(Icons.date_range, color: Colors.indigo),
                      title: const Text('Created At'),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd – HH:mm').format(displayDate),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: currentTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _createdAt = picked;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('SUBMIT FORM',
                          style: TextStyle(letterSpacing: 1)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     backgroundColor: Colors.indigo,
                          //     content: Text(
                          //       'Form submitted by ${currentUser?.email ?? 'Unknown user'}\n'
                          //       'Batch: $_selectedBatch | Semester: $_selectedSemester\n'
                          //       'Department: $_selectedDept',
                          //       style: const TextStyle(color: Colors.white),
                          //     ),
                          //   ),
                          // );
                          create_channel();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
