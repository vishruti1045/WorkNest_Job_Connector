import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController(); // Add company controller

  Future<void> postJob() async {
    FocusScope.of(context).unfocus(); // Prevents pointer crash

    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final type = _typeController.text.trim();
    final description = _descriptionController.text.trim();
    final company = _companyController.text.trim(); // Get company name

    if (title.isEmpty || location.isEmpty || type.isEmpty || description.isEmpty || company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // Split the job title and description into keywords for easy searching
      final keywordsList = (title + " " + description)
    .toLowerCase()
    .split(RegExp(r'\s+')) // split on multiple spaces
    .where((word) => word.trim().isNotEmpty) // remove empty strings
    .toSet()
    .toList(); // ensure unique keywords


      // Adding the job to Firestore
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': title,
        'location': location,
        'type': type,
        'description': description,
        'company': company, // Include company field
        'keywords': keywordsList, // Store keywords for searching
        'timestamp': FieldValue.serverTimestamp(),
        'postedBy': FirebaseAuth.instance.currentUser?.uid ?? "anonymous",
      });

      _titleController.clear();
      _locationController.clear();
      _typeController.clear();
      _descriptionController.clear();
      _companyController.clear(); // Clear company controller

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Job Posted Successfully!")),
      );

      // Show dialog after frame to avoid pointer crash
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Success"),
            content: Text("Your job has been posted."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error posting job: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post a Job"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Job Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Job Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _companyController, // New input field for company name
              decoration: InputDecoration(
                labelText: 'Company',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: postJob,
              child: Text("Post Job"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
