import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/JobDetailsScreen.dart';  // Import the JobDetailsScreen

class JobSearchScreen extends StatefulWidget {
  @override
  _JobSearchScreenState createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  // Perform search based on entered keywords
  Future<void> searchJobs() async {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a keyword to search")),
      );
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .where('keywords', arrayContains: query) // Search for jobs that match the keyword
        .get();

    setState(() {
      _searchResults = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Search')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for Jobs',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: searchJobs,
              child: Text("Search"),
            ),
            SizedBox(height: 20),
            _searchResults.isEmpty
                ? Center(child: Text("No results found"))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final job = _searchResults[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(job['title'] ?? 'No Title Available'),
                          subtitle: Text(job['location'] ?? 'No Location Available'),
                          onTap: () {
                            // Navigate to the job details screen with the selected job's data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailsScreen(job: job),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
