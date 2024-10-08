import 'package:flutter/material.dart';
import 'blood_sugar_screen.dart';
import 'food_diary_screen.dart';
import 'medication_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diabetes Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => BloodSugarScreen())),
              child: Text('Log Blood Sugar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodDiaryScreen())),
              child: Text('Food Diary'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MedicationScreen())),
              child: Text('Medication'),
            ),
          ],
        ),
      ),
    );
  }
}
