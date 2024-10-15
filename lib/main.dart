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
import 'services/api_service.dart'; // Added import
import 'providers/auth_provider.dart' as app_auth; // Changed import

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
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: getBaseUrl()),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => app_auth.AuthProvider(
            // Changed to use app_auth prefix
            Provider.of<ApiService>(context, listen: false),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

// Function to determine the base URL based on the platform
String getBaseUrl() {
  // For Web
  if (Uri.base.scheme == 'http') {
    return 'http://127.0.0.1:8000';
  } else {
    // For Android Emulator
    return 'http://10.0.2.2:8000';
    // For iOS Simulator, you can use 'http://127.0.0.1:8000' or your machine's IP address
  }
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
          // Define routes for better navigation handling
          
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            // Additional routes can be managed within their respective screens or added here
          },
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                if (user == null) {
                  return LoginScreen(); // Show unauthenticated screen
                }
                return HomeScreen(); // Show authenticated screen
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
