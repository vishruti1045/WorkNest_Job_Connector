import 'package:flutter/material.dart';
import './routes/named_routes.dart';
import 'screens/FullPageJobScreen .dart'; // Import the full page job screen
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/register_screen.dart';
import './screens/splash_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

// Initialize Google Sign-In
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",  // Set the Web Client ID
);


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Portal',
      initialRoute: NamedRoutes.splashScreen,  // Set the initial route
      routes: {
        NamedRoutes.splashScreen: (context) => SplashScreen(),
        NamedRoutes.logIn: (context) => LoginScreen(),
        NamedRoutes.registerScreen: (context) => RegisterScreen(),
        NamedRoutes.homeScreen: (context) => HomeScreen(),
        NamedRoutes.fullPageJob: (context) => FullPageJobScreen(),  // Add full page job route
        // Add other routes as necessary
      },
    );
  }
}
