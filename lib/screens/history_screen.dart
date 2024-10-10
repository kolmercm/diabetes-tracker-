import 'package:flutter/material.dart';
import '../widgets/health_calendar_widget.dart';
import '../models/medication.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../providers/food_item_provider.dart'; // Ensure FoodItemProvider is imported
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/food_item.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final medications = Provider.of<MedicationProvider>(context).medications;
    final foodItems = Provider.of<FoodItemProvider>(context).foodItems;
    final exercises = Provider.of<ExerciseProvider>(context).exercises;

    // Combine dates from medications, food items, and exercises
    Set<DateTime> eventDays = {};

    for (var med in medications) {
      eventDays.add(
          DateTime(med.dateTime.year, med.dateTime.month, med.dateTime.day));
    }

    for (var food in foodItems) {
      eventDays.add(
          DateTime(food.dateTime.year, food.dateTime.month, food.dateTime.day));
    }

    for (var exercise in exercises) {
      eventDays.add(DateTime(exercise.dateTime.year, exercise.dateTime.month,
          exercise.dateTime.day));
    }

    // Separate sets for medications, food items, and exercises
    Set<DateTime> medicationDays = medications
        .map((med) =>
            DateTime(med.dateTime.year, med.dateTime.month, med.dateTime.day))
        .toSet();
    Set<DateTime> foodEventDays = foodItems
        .map((food) => DateTime(
            food.dateTime.year, food.dateTime.month, food.dateTime.day))
        .toSet();
    Set<DateTime> exerciseEventDays = exercises
        .map((exercise) => DateTime(exercise.dateTime.year,
            exercise.dateTime.month, exercise.dateTime.day))
        .toSet();

    // Filter based on selected day
    List<Medication> filteredMedications = _selectedDay == null
        ? []
        : medications
            .where((med) => isSameDay(med.dateTime, _selectedDay!))
            .toList();

    List<FoodItem> filteredFoodItems = _selectedDay == null
        ? []
        : foodItems
            .where((food) => isSameDay(food.dateTime, _selectedDay!))
            .toList();

    List<Exercise> filteredExercises = _selectedDay == null
        ? []
        : exercises
            .where((exercise) => isSameDay(exercise.dateTime, _selectedDay!))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        children: [
          // {{ Pass medicationDays, foodEventDays, and exerciseEventDays to HealthCalendarWidget }}
          HealthCalendarWidget(
            eventDays: eventDays,
            medicationDays: medicationDays,
            foodEventDays: foodEventDays,
            exerciseEventDays: exerciseEventDays, // New argument for exercises
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              // Additional functionality can be added here if needed
            },
          ),
          SizedBox(height: 20),
          // Display selected day's medications, food items, and exercises
          Expanded(
            child: _selectedDay == null
                ? Center(child: Text('Please select a day to view history.'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // {{ Display selected date }}
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDay!),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // {{ Medications Section }}
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Medications',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        filteredMedications.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                    'No medications recorded for this day.'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredMedications.length,
                                itemBuilder: (context, index) {
                                  final medication = filteredMedications[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: ListTile(
                                      title: Text(medication.type),
                                      subtitle: Text(
                                          'Amount: ${medication.amount}\nTime: ${TimeOfDay.fromDateTime(medication.dateTime).format(context)}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Confirm deletion
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Confirm Deletion'),
                                              content: Text(
                                                  'Are you sure you want to delete this medication?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await Provider.of<
                                                                MedicationProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeMedication(
                                                            medication);
                                                    Navigator.of(ctx).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Medication deleted')),
                                                    );
                                                  },
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
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
                        // {{ Food Items Section }}
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Food Items',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        filteredFoodItems.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                    'No food items recorded for this day.'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredFoodItems.length,
                                itemBuilder: (context, index) {
                                  final food = filteredFoodItems[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: ListTile(
                                      title: Text(food.name),
                                      subtitle: Text(
                                          'Amount: ${food.amount}\nTime: ${DateFormat('HH:mm').format(food.dateTime)}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Confirm deletion
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Confirm Deletion'),
                                              content: Text(
                                                  'Are you sure you want to delete this food item?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Provider.of<FoodItemProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeFoodItem(food);
                                                    Navigator.of(ctx).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Food item deleted')),
                                                    );
                                                  },
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
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
                        // {{ Exercises Section }}
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'Exercises',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        filteredExercises.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    Text('No exercises recorded for this day.'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = filteredExercises[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4.0),
                                    child: ListTile(
                                      title: Text(exercise.name),
                                      subtitle: Text(
                                          'Duration: ${exercise.duration}\nTime: ${DateFormat('HH:mm').format(exercise.dateTime)}'),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // Confirm deletion
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
                                                  onPressed: () async {
                                                    Provider.of<ExerciseProvider>(
                                                            context,
                                                            listen: false)
                                                        .removeExercise(
                                                            exercise);
                                                    Navigator.of(ctx).pop();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Exercise deleted')),
                                                    );
                                                  },
                                                  child: Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
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
        ],
      ),
    );
  }
}
