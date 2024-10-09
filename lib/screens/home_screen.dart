import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'blood_sugar_screen.dart';
import 'food_diary_screen.dart';
import 'medication_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'login_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  final String initialRoute;

  HomeScreen({Key? key, this.initialRoute = '/home'}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  final List<String> _routes = ['/home', '/history', '/profile', '/settings'];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _routes.indexOf(widget.initialRoute);
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (kIsWeb) {
      // Update URL only for web platform
      _updateWebUrl(_routes[index]);
    }
  }

  void _updateWebUrl(String path) {
    // This function updates the URL without triggering a page reload
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diabetes Tracker'),
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => _onItemTapped(2), // Profile index
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeContent(),
          HistoryScreen(),
          ProfileScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Your History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FoodDiaryScreen())),
            child: Text('Food Diary'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add this check before navigating to MedicationScreen
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MedicationScreen()));
              } else {
                // If not authenticated, navigate to LoginScreen
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
