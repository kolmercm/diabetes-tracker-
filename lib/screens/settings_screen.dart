import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedGlucoseUnit = 'mg/dL';
  RangeValues _glucoseRange = RangeValues(70, 180);
  TimeOfDay? _reminderTime;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Notifications Toggle
          SwitchListTile(
            title: Text('Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Implement the logic to handle notification settings
            },
          ),

          // Language Selection
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                  // TODO: Implement the logic to handle language change
                }
              },
              items: <String>['English', 'Spanish', 'French', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          // Theme Selection
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  themeProvider.setThemeMode(newValue);
                }
              },
              items: ThemeMode.values
                  .map<DropdownMenuItem<ThemeMode>>((ThemeMode value) {
                return DropdownMenuItem<ThemeMode>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
          ),

          // Glucose Unit Selection
          ListTile(
            title: Text('Glucose Unit'),
            trailing: DropdownButton<String>(
              value: _selectedGlucoseUnit,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGlucoseUnit = newValue;
                    // TODO: Implement conversion logic if needed
                  });
                }
              },
              items: <String>['mg/dL', 'mmol/L']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          // Target Glucose Range
          ListTile(
            title: Text('Target Glucose Range'),
            subtitle: RangeSlider(
              values: _glucoseRange,
              min: 0,
              max: 300,
              divisions: 300,
              labels: RangeLabels(
                _glucoseRange.start.round().toString(),
                _glucoseRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _glucoseRange = values;
                });
                // TODO: Implement the logic to save target range
              },
            ),
          ),

          // Reminder Time
          ListTile(
            title: Text('Reminder Time'),
            trailing: TextButton(
              child: Text(_reminderTime == null
                  ? 'Set Time'
                  : _reminderTime!.format(context)),
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime:
                      _reminderTime ?? TimeOfDay.fromDateTime(DateTime.now()),
                );
                if (picked != null) {
                  setState(() {
                    _reminderTime = picked;
                  });
                  // TODO: Implement the logic to save reminder time
                }
              },
            ),
          ),

          // Export Data
          ListTile(
            title: Text('Export Data'),
            trailing: IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
                // TODO: Implement the logic to export data
              },
            ),
          ),

          // Privacy Policy
          ListTile(
            title: Text('Privacy Policy'),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // TODO: Navigate to Privacy Policy screen
              },
            ),
          ),

          // Terms of Service
          ListTile(
            title: Text('Terms of Service'),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // TODO: Navigate to Terms of Service screen
              },
            ),
          ),

          // About Section
          ListTile(
            title: Text('About'),
            trailing: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                // Show About dialog
                showAboutDialog(
                  context: context,
                  applicationName: 'Diabetes Tracker',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2023 Your Company',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
