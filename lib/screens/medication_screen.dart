import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicationScreen extends StatefulWidget {
  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final TextEditingController _medicationTypeController =
      TextEditingController();
  final TextEditingController _medicationAmountController =
      TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  String _savedMedication = '';

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  void _saveMedication() {
    setState(() {
      _savedMedication = 'Medication: ${_medicationTypeController.text}\n'
          'Amount: ${_medicationAmountController.text}\n'
          'Date/Time: ${_dateTimeController.text}';
    });
    // Clear the text fields after saving
    _medicationTypeController.clear();
    _medicationAmountController.clear();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timePicked != null) {
        setState(() {
          _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime(picked.year, picked.month, picked.day, timePicked.hour,
                timePicked.minute),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ElevatedButton(
              onPressed: _saveMedication,
              child: Text('Save Medication'),
            ),
            SizedBox(height: 24),
            Text(
              'Saved Medication:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(_savedMedication),
          ],
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
