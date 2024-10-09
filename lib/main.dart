import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart'; // Added import
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/medication_provider.dart'; // Added import
import 'firebase_options.dart';
import 'providers/theme_provider.dart'; // Ensure this is included

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()), // Provided MedicationProvider
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
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            if (settings.name == '/login') {
              return MaterialPageRoute(builder: (context) => LoginScreen());
            } else {
              final uri = Uri.parse(settings.name!);
              final initialRoute = uri.path;
              return MaterialPageRoute(
                builder: (context) => HomeScreen(initialRoute: initialRoute),
                settings: settings,
              );
            }
          },
        );
      },
    );
  }
}