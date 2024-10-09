import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
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
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to About screen
              // You can implement this later
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Privacy Policy screen
              // You can implement this later
            },
          ),
          ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to Terms of Service screen
              // You can implement this later
            },
          ),
        ],
      ),
    );
  }
}
