import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/medication_provider.dart';
import '../models/medication.dart';
import 'package:flutter/foundation.dart';

class MedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  late final TextEditingController _medicationTypeController;
  late final TextEditingController _medicationAmountController;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    _medicationTypeController =
        TextEditingController(text: kDebugMode ? 'Aspirin' : null);
    _medicationAmountController =
        TextEditingController(text: kDebugMode ? '500mg' : null);
  }

  void _saveMedication() {
    final String type = _medicationTypeController.text.trim();
    final String amount = _medicationAmountController.text.trim();
    final String dateTimeStr = _dateTimeController.text.trim();

    if (type.isEmpty || amount.isEmpty || dateTimeStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final DateTime dateTime =
        DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeStr, true).toLocal();

    final Medication medication = Medication(
      type: type,
      amount: amount,
      dateTime: dateTime,
    );

    Provider.of<MedicationProvider>(context, listen: false)
        .addMedication(medication);

    // Clear the text fields after saving
    _medicationTypeController.clear();
    _medicationAmountController.clear();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medication saved successfully')),
    );
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
    final medications = Provider.of<MedicationProvider>(context).medications;

    return Scaffold(
      appBar: AppBar(title: Text('Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Prevents overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medication Type
              Text(
                'Enter Medication Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _medicationTypeController,
                decoration: InputDecoration(
                  hintText: 'e.g., Aspirin, Ibuprofen',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Medication Amount
              Text(
                'Enter Medication Amount:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _medicationAmountController,
                decoration: InputDecoration(
                  hintText: 'e.g., 500mg, 2 tablets',
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
                onPressed: _saveMedication,
                child: Text('Save Medication'),
              ),
              SizedBox(height: 24),

              // Saved Medications
              Text(
                'Saved Medications:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              medications.isEmpty
                  ? Text('No medications saved.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        return Card(
                          child: ListTile(
                            title: Text(medication.type),
                            subtitle: Text(
                                'Amount: ${medication.amount}\nDate/Time: ${DateFormat('yyyy-MM-dd HH:mm').format(medication.dateTime)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Show confirmation dialog before deletion
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
                                        onPressed: () {
                                          Provider.of<MedicationProvider>(
                                                  context,
                                                  listen: false)
                                              .removeMedication(medication);
                                          Navigator.of(ctx).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Medication deleted')),
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
    _medicationTypeController.dispose();
    _medicationAmountController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }
}