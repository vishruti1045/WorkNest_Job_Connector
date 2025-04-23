import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Navigate to Register screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,  // Adding a background color to match the brand theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo in the center
            Image.asset(
              'assets/logo.jpg',  // Make sure you place the logo image in the assets folder
              width: 150,  // You can adjust the size of the logo here
              height: 150,
            ),
            SizedBox(height: 20),
            // App Name Text
            Text(
              'Welcome to WorkNest!',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,  // Change text color for visibility
                letterSpacing: 2.0,  // Slightly increased letter spacing for a modern look
              ),
            ),
            SizedBox(height: 10),
            // Optional loading indicator or animation
            CircularProgressIndicator(
              color: Colors.white,  // Matching the theme
            ),
          ],
        ),
      ),
    );
  }
}
