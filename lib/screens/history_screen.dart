import 'package:flutter/material.dart';
import '../widgets/health_calendar_widget.dart';
import '../models/medication.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../providers/food_item_provider.dart'; // Ensure FoodItemProvider is imported
import 'package:table_calendar/table_calendar.dart';

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

    // Combine dates from medications and food items
    Set<DateTime> eventDays = {};

    for (var med in medications) {
      eventDays.add(
          DateTime(med.dateTime.year, med.dateTime.month, med.dateTime.day));
    }

    for (var food in foodItems) {
      eventDays.add(
          DateTime(food.dateTime.year, food.dateTime.month, food.dateTime.day));
    }

    // Filter medications based on the selected day
    List<Medication> filteredMedications = _selectedDay == null
        ? []
        : medications.where((med) {
            return isSameDay(med.dateTime, _selectedDay!); // Fixed: Added '!'
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        children: [
          // Pass eventDays to HealthCalendarWidget
          HealthCalendarWidget(
            eventDays: eventDays, // {{ Added eventDays parameter }}
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              // Additional functionality can be added here if needed
            },
          ),
          SizedBox(height: 20),
          // Display selected day's medications
          Expanded(
            child: _selectedDay == null
                ? Center(child: Text('Please select a day to view history.'))
                : filteredMedications.isEmpty
                    ? Center(
                        child: Text('No medications recorded for this day.'))
                    : ListView.builder(
                        itemCount: filteredMedications.length,
                        itemBuilder: (context, index) {
                          final medication = filteredMedications[index];
                          return Card(
                            child: ListTile(
                              title: Text(medication.type),
                              subtitle: Text(
                                  'Amount: ${medication.amount}\nTime: ${TimeOfDay.fromDateTime(medication.dateTime).format(context)}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
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
                                                .removeMedication(medication);
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Medication deleted')),
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
          ),
        ],
      ),
    );
  }
}
