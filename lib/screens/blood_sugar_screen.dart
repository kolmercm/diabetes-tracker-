import 'package:flutter/material.dart';
import '../services/database_service.dart' as db_service;
import '../models/blood_sugar.dart';
import '../widgets/blood_sugar_chart.dart';


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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Blood Sugar')),
      body: Column(
        children: [
          TextField(
              controller: levelController,
              decoration: InputDecoration(labelText: 'Blood Sugar Level')),
          ElevatedButton(onPressed: _logBloodSugar, child: Text('Log')),
          // Add your BloodSugarChart widget here to show data
        ],
      ),
    );
  }
}
