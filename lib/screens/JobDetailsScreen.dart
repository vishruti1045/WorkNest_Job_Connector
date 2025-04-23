import 'package:flutter/material.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;  // Declare a field to store the job data

  JobDetailsScreen({required this.job});  // Constructor to accept the job data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(job['title'] ?? 'Job Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${job['title'] ?? 'No Title Available'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${job['location'] ?? 'No Location Available'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${job['description'] ?? 'No Description Available'}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more job details here if needed
          ],
        ),
      ),
    );
  }
}
