import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isRecruiter;

  ProfileScreen({required this.isRecruiter});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> fetchUserDetails() {
    return FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).get();
  }

  Future<QuerySnapshot> fetchSavedJobs() {
    return FirebaseFirestore.instance
        .collection('saved_jobs')
        .where('userId', isEqualTo: currentUser?.uid)
        .get();
  }

  Future<QuerySnapshot> fetchPostedJobs() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('postedBy', isEqualTo: currentUser?.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchUserDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("👤 Name: ${userData['name'] ?? currentUser?.displayName ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                Text("📧 Email: ${currentUser?.email ?? 'N/A'}", style: TextStyle(fontSize: 18)),
                Text("🔖 Role: ${isRecruiter ? 'recruiter' : 'seeker'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 24),
                Text(isRecruiter ? '📢 Posted Jobs' : '💾 Saved Jobs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                FutureBuilder<QuerySnapshot>(
                  future: isRecruiter ? fetchPostedJobs() : fetchSavedJobs(),
                  builder: (context, jobSnapshot) {
                    if (!jobSnapshot.hasData) return CircularProgressIndicator();

                    final jobs = jobSnapshot.data!.docs;

                    if (jobs.isEmpty) {
                      return Text("No jobs to display.");
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index].data() as Map<String, dynamic>;
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(job['title'] ?? 'No Title'),
                            subtitle: Text("📍 ${job['location'] ?? 'Unknown'}"),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
