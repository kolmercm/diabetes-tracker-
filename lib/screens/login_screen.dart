import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added import
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController =
        TextEditingController(text: kDebugMode ? 'kolmercm@gmail.com' : null);
    passwordController =
        TextEditingController(text: kDebugMode ? '1Cardinals1!' : null);
  }

  void _login() async {
    final user = await _authService.signIn(
        emailController.text, passwordController.text);
    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Login failed. Please check your credentials and try again.')),
      );
    }
  }

  // Add Google Sign-In method
  void _loginWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Handle Google sign-in failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed. Please try again.')),
      );
    }
  }

  // Helper method to get the appropriate Google logo based on theme
  String _getGoogleLogoAsset(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? 'assets/icons/google_logo_dark.svg'
        : 'assets/icons/google_logo_light.svg';
  }

  @override
  Widget build(BuildContext context) {
    // Redirect if already authenticated
    if (FirebaseAuth.instance.currentUser != null) {
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
      return Scaffold(); // Return empty scaffold while redirecting
    }

    // Determine current theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            SizedBox(height: 10),
            // Add Google Sign-In button with SVG icon
            ElevatedButton(
              onPressed: _loginWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? Colors.grey[800]
                    : Colors.white, // Dynamic background
                foregroundColor:
                    isDarkMode ? Colors.white : Colors.black, // Text color
                minimumSize: Size(double.infinity, 50),
                side: BorderSide(
                  color: isDarkMode
                      ? Colors.white
                      : Colors.grey, // Dynamic outline
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    _getGoogleLogoAsset(context),
                    height: 24.0,
                  ),
                  SizedBox(width: 10),
                  Text('Sign in with Google'),
                ],
              ),
            ),
            // Add a sign-up link
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
