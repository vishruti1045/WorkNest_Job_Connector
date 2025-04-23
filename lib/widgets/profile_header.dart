import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/color_styles.dart';
import '../widgets/vertical_space.dart'; // Assuming you have this widget

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.boldWelcomeText,
    required this.lightWelcomeText,
  });

  final String lightWelcomeText;
  final String boldWelcomeText;

  @override
  Widget build(BuildContext context) {
    // Fetch the current user from Firebase Authentication
    final User? user = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the light welcome text
        Text(
          lightWelcomeText,
          style: const TextStyle(
            fontSize: 14,
            color: ColorStyles.c95969d,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Space between text widgets
        VerticalSpace(value: 5, ctx: context),
        
        // Display the bold welcome text
        Text(
          boldWelcomeText,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ColorStyles.c0d0d26,
          ),
        ),
        // Space between text widgets
        VerticalSpace(value: 10, ctx: context),
        
        // Show user profile information if logged in
                if (user != null) ...[
          Text('Hello, ${user.displayName ?? 'User'}'), // Display user's name
          Text('Email: ${user.email ?? 'Not available'}'), // Display user's email
          if (user.photoURL != null) 
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.network(
                user.photoURL!, // Display user's profile picture
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
        ] else ...[
          Text('Please log in to view your profile'),
        ],
      ]
    );
  }
}
