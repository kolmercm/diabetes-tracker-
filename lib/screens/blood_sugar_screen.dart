import 'package:flutter/material.dart';
import '../services/database_service.dart' as db_service;
import '../models/blood_sugar.dart';
import '../widgets/blood_sugar_log_list.dart'; // Add this import

class BloodSugarScreen extends StatefulWidget {
  @override
  _BloodSugarScreenState createState() => _BloodSugarScreenState();
}

class _BloodSugarScreenState extends State<BloodSugarScreen> {
  final TextEditingController levelController = TextEditingController();
  final db_service.DatabaseService _dbService = db_service.DatabaseService();

  void _logBloodSugar() async {
    double level = double.parse(levelController.text);
    BloodSugar bloodSugar =
        BloodSugar(id: '', level: level, dateTime: DateTime.now());
    await _dbService.addBloodSugar(bloodSugar);
    setState(() {
      levelController.clear(); // Clear the input field after logging
    });
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
          // Add the BloodSugarLogList widget here
          Expanded(
            child: BloodSugarLogList(),
          ),
        ],
      ),
    );
  }
}
