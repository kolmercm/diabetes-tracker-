import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added import

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final user = await _authService.signUp(
        emailController.text, passwordController.text);
    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account. Please try again.')),
      );
    }
  }

  // Add Google Sign-Up method
  void _signUpWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // Handle sign-up failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-up failed. Please try again.')),
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
    // Determine current theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
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
            TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
            SizedBox(height: 10),
            // Add Google Sign-Up button with SVG icon
            ElevatedButton(
              onPressed: _signUpWithGoogle,
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
                  Text('Sign up with Google'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
