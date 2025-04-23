import 'package:flutter/material.dart';
import 'job_list_screen.dart';
import 'post_job_screen.dart';
import 'profile_screen.dart';
import 'job_search_screen.dart'; // Import the search screen
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRecruiter = false;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        isRecruiter = doc.data()?['role'] == 'recruiter';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isRecruiter ? 3 : 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("WorkNest"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.search), text: "Jobs"),
              if (isRecruiter) Tab(icon: Icon(Icons.add), text: "Post Job"),
              Tab(icon: Icon(Icons.person), text: "Profile"),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => AuthService().signOut(context),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00B894), // Soft green
                Color(0xFF0984E3), // Soft blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TabBarView(
            children: [
              // Jobs Tab (with Search Button + Job List)
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JobSearchScreen()),
                            );
                          },
                          child: Text(
                            '🔍 Search Jobs',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: JobListScreen()),
                  ],
                ),
              ),

              // Post Job Tab (only if recruiter)
              if (isRecruiter) PostJobScreen(),

              // Profile Tab
              ProfileScreen(isRecruiter: isRecruiter),
            ],
          ),
        ),
      ),
    );
  }
}
