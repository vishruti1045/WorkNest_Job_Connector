import 'package:flutter/material.dart';

class FullPageJobScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve job data passed as arguments
    final job = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${job['location']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Description: ${job['description']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Add more fields as needed, like job requirements, company info, etc.
          ],
        ),
      ),
    );
  }
}
