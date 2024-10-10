import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Added import
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/medication_provider.dart'; // Added import
import 'firebase_options.dart';
import 'providers/theme_provider.dart'; // Ensure this is included
import 'providers/food_item_provider.dart'; // Add this import
import 'providers/exercise_provider.dart'; // Add this import
// import 'screens/signup_screen.dart'; // Added import
// import 'screens/history_screen.dart'; // Added import
// import 'screens/exercises_screen.dart'; // Add this import
// import 'screens/settings_screen.dart'; // Add this import
// import 'screens/profile_screen.dart'; // Add this import
// import 'screens/blood_sugar_screen.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
        ChangeNotifierProvider(create: (_) => FoodItemProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Diabetes Tracker',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false, // Optional: Remove debug banner
          // NEW: Define routes for better navigation handling
          routes: {
            '/login': (context) => LoginScreen(),
            // '/signup': (context) => SignUpScreen(),
            '/home': (context) => HomeScreen(),
            // '/blood_sugar': (context) => BloodSugarScreen(),
            // '/history': (context) => HistoryScreen(),
            // '/exercises': (context) => ExercisesScreen(),
            // '/profile': (context) => ProfileScreen(),
            // '/settings': (context) => SettingsScreen(),
          },
          // onGenerateRoute: (settings) {
          //   // ERROR HANDLING: Handle undefined routes
          //   if (settings.name == null) {
          //     return MaterialPageRoute(builder: (context) => LoginScreen());
          //   }
          //   switch (settings.name) {
          //     case '/login':
          //       return MaterialPageRoute(builder: (context) => LoginScreen());
          //     case '/signup':
          //       return MaterialPageRoute(builder: (context) => SignUpScreen());
          //     case '/home':
          //       return MaterialPageRoute(builder: (context) => HomeNavigator());
          //     // Add cases for other routes if necessary
          //     default:
          //       return MaterialPageRoute(builder: (context) => LoginScreen());
          //   }
          // },
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                if (user == null) {
                  return LoginScreen(); // Show unauthenticated navigator
                }
                return HomeScreen(); // Show authenticated navigator
              }
              // Loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
