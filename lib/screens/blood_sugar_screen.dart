import 'package:flutter/material.dart';
import '../services/database_service.dart' as db_service;
import '../models/blood_sugar.dart';
import '../widgets/blood_sugar_log_list.dart'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';

class BloodSugarScreen extends StatefulWidget {
  @override
  _BloodSugarScreenState createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  final TextEditingController levelController = TextEditingController();
  final db_service.DatabaseService _dbService = db_service.DatabaseService();

  void _logBloodSugar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to log blood sugar')),
      );
      return;
    }

    double level = double.tryParse(levelController.text) ?? 0;
    if (level <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid blood sugar level')),
      );
      return;
    }

    BloodSugar bloodSugar = BloodSugar(
      id: '',
      userId: user.uid,
      level: level,
      dateTime: DateTime.now(),
    );

    try {
      await _dbService.addBloodSugar(bloodSugar);
      setState(() {
        levelController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging blood sugar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Sugar Log')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: levelController,
                    decoration: InputDecoration(labelText: 'Blood Sugar Level'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(onPressed: _logBloodSugar, child: Text('Log')),
              ],
            ),
          ),
          Expanded(
            child: BloodSugarLogList(),
          ),
        ],
      ),
    );
  }
}
