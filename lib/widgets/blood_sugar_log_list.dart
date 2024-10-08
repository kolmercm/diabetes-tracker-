import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import '../services/database_service.dart';
import '../models/blood_sugar.dart';

class BloodSugarLogList extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BloodSugar>>(
      stream: _dbService.getBloodSugar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No blood sugar logs yet.'));
        }

        List<BloodSugar> logs = snapshot.data!;
        logs.sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Sort by date, newest first

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            BloodSugar log = logs[index];
            return ListTile(
              title: Text('${log.level} mg/dL'),
              subtitle: Text(DateFormat('MMM d, y HH:mm').format(log.dateTime)),
              trailing: Icon(
                Icons.circle,
                color: _getColorForBloodSugar(log.level),
              ),
            );
          },
        );
      },
    );
  }

  Color _getColorForBloodSugar(double level) {
    if (level < 70) return Colors.red;
    if (level > 180) return Colors.orange;
    return Colors.green;
  }
}