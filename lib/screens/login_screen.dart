import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/named_routes.dart';  // Import NamedRoutes class
import '../screens/register_screen.dart';  // Import RegisterScreen
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to Home screen after successful login using NamedRoutes
      Navigator.pushReplacementNamed(context, NamedRoutes.homeScreen);  // Ensure homeScreen is correctly defined in NamedRoutes
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login Failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> thirdPartyLogin() async {
    try {
      // Create an instance of GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Get the authentication details from the Google account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase using the Google authentication details
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // On successful sign-in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In Successful'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to Home screen after successful login using NamedRoutes
      Navigator.pushReplacementNamed(context, NamedRoutes.homeScreen);

    } catch (e) {
      // Handle sign-in errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("Login"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, NamedRoutes.registerScreen);  // Use NamedRoutes for navigation
              },
              child: Text('Sign Up', style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                thirdPartyLogin(); // Google login method
              },
              child: Text('Login with Google', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
