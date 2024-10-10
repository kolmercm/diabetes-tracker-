import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  void _saveExercise() async {
    try {
      final String name = _exerciseNameController.text.trim();
      final String duration = _durationController.text.trim();
      final String dateTimeStr = _dateTimeController.text.trim();

      if (name.isEmpty || duration.isEmpty || dateTimeStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      final DateTime dateTime =
          DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeStr, true).toLocal();

      final Exercise exercise = Exercise(
        name: name,
        duration: duration,
        dateTime: dateTime,
      );

      await Provider.of<ExerciseProvider>(context, listen: false)
          .addExercise(exercise);

      // Clear the text fields after saving
      _exerciseNameController.clear();
      _durationController.clear();
      _dateTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercise saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = Provider.of<ExerciseProvider>(context).exercises;

    return Scaffold(
      appBar: AppBar(title: Text('Exercises')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Prevents overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Name
              Text(
                'Enter Exercise Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _exerciseNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Running, Yoga',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Duration
              Text(
                'Enter Duration:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(
                  hintText: 'e.g., 30 minutes, 1 hour',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),

              // Date and Time
              Text(
                'Date and Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD HH:MM',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDateTime,
                  ),
                ),
                readOnly: true,
                onTap: _selectDateTime,
              ),
              SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveExercise,
                child: Text('Save Exercise'),
              ),
              SizedBox(height: 24),

              // Saved Exercises
              Text(
                'Saved Exercises:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              exercises.isEmpty
                  ? Text('No exercises saved.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Card(
                          child: ListTile(
                            title: Text(exercise.name),
                            subtitle: Text(
                                'Duration: ${exercise.duration}\nDate/Time: ${DateFormat('yyyy-MM-dd HH:mm').format(exercise.dateTime)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog before deletion
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Confirm Deletion'),
                                    content: Text(
                                        'Are you sure you want to delete this exercise?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<ExerciseProvider>(context,
                                                  listen: false)
                                              .removeExercise(exercise);
                                          Navigator.of(ctx).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Exercise deleted')),
                                          );
                                        },
                                        child: Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _durationController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }
}
