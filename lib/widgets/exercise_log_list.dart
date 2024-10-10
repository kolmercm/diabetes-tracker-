import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/exercise.dart';

class ExerciseLogList extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>>(
      stream: _dbService.getExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No exercises logged yet.'));
        }

        List<Exercise> logs = snapshot.data!;
        logs.sort((a, b) =>
            b.dateTime.compareTo(a.dateTime)); // Sort by date, newest first

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            Exercise log = logs[index];
            return ListTile(
              title: Text('${log.name}'),
              subtitle: Text(
                  '${log.duration} • ${DateFormat('MMM d, y HH:mm').format(log.dateTime)}'),
              trailing: Icon(
                Icons.fitness_center,
                color: Colors.green,
              ),
            );
          },
        );
      },
    );
  }
}
