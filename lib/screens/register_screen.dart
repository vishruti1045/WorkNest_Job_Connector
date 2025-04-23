import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import '../routes/named_routes.dart'; // Ensure to import your route constants

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedRole = 'job_seeker';
  bool _isPasswordVisible = false;

  bool validateFields() {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        !_isEmailValid(_emailController.text) ||
        _passwordController.text.length < 6) {
      return false;
    }
    return true;
  }

  bool _isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  void registerUser() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Register the user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      // Save user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': _emailController.text.trim(),
        'name': _nameController.text.trim(),
        'role': _selectedRole,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear input fields
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();

      // Navigate to the home screen
      Navigator.pushReplacementNamed(context, NamedRoutes.homeScreen);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration Failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email is already in use';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password should be at least 6 characters';
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
          content: Text('An unexpected error occurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: !_isPasswordVisible,
            ),
            IconButton(
              icon: Icon(_isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: [
                DropdownMenuItem(value: 'job_seeker', child: Text('Job Seeker')),
                DropdownMenuItem(value: 'recruiter', child: Text('Recruiter')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Role'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, NamedRoutes.logIn);
              },
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
