import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'blood_sugar_screen.dart';
import 'food_diary_screen.dart';
import 'medication_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'exercises_screen.dart';
import 'settings_screen.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String initialRoute;

  HomeScreen({Key? key, this.initialRoute = '/home'}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  // add profile index constant
  final int profileIndex = 3;
  // late List<Widget> _pages;

  // List of routes corresponding to each tab
  final List<String> _routes = [
    '/home',
    '/history',
    '/exercises', // 'could be /medication'
    '/profile',
    '/settings',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _routes.indexOf(widget.initialRoute);
    if (_selectedIndex == -1) _selectedIndex = 0;
    // _pages = [
    //   HomeContent(onNavigate: _onItemTapped), // Home Content
    //   HistoryScreen(),
    //   ExercisesScreen(),
    //   ProfileScreen(),
    //   SettingsScreen(),
    // ];
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      if (kIsWeb) {
        _updateWebUrl(
            _routes[index]); // Ensures URL reflects the current tab on web
      }
    }
  }

  void _updateWebUrl(String path) {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Update the URL without replacing the current route
        Navigator.of(context).pushNamed(path);
      });
    } catch (e) {
      // ERROR HANDLING: Log or handle navigation errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating web URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Tracker'),
        // NEW: Add home icon on the left side
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _onItemTapped(0), // Navigate to Home
        ),
        actions: [
          // MOVED: Profile icon button
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => _onItemTapped(3), // Navigate to Profile
          ),
          // EXISTING: Logout icon button
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await AuthService().signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              } catch (e) {
                // ERROR HANDLING: Show error message if sign out fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeContent(),
          HistoryScreen(),
          ExercisesScreen(),
          ProfileScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Allows more than 3 items
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Changed icon to home for clarity
            label: 'Home', // Changed label to Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  // final Function(int) onNavigate;

  // HomeContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BloodSugarScreen())),
            child: Text('Log Blood Sugar'),
          ),
          SizedBox(height: 16), // Added spacing between buttons
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FoodDiaryScreen())),
            child: Text('Food Diary'),
          ),
          SizedBox(height: 16), // Added spacing between buttons
          ElevatedButton(
            onPressed: () {
              // Add this check before navigating to MedicationScreen
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MedicationScreen()));
              } else {
                // For mobile: Use pushReplacement with MaterialPageRoute
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            child: Text('Medication'),
          ),
        ],
      ),
    );
  }
}
