// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/login_screen.dart';
import '../screens/job_list_screen.dart';
import '../screens/post_job_screen.dart';

class AuthService {
  // Automatically redirect based on user role
  Widget handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final role = userSnapshot.data!['role'];
                if (role == 'recruiter') {
                  return PostJobScreen();
                } else {
                  return JobListScreen();
                }
              } else {
                return const Center(child: Text('User data not found.'));
              }
            },
          );
        } else {
          return LoginScreen(); // Show login screen if no user is logged in
        }
      },
    );
  }

  // Sign out method and navigate to login screen
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login after sign out
  }
}
