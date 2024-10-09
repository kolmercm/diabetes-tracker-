import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Center(
        child: Text('No user is currently signed in.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display User Email
          ListTile(
            leading: Icon(Icons.email),
            title: Text('Email'),
            subtitle: Text(user!.email ?? 'No email available'),
          ),
          Divider(),
          // Display User UID
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User ID'),
            subtitle: Text(user!.uid),
          ),
          Divider(),
          // Display Additional Information (if available)
          // Add more ListTiles here if you have additional user data

          SizedBox(height: 20),
          // Sign Out Button
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: Icon(Icons.logout),
            label: Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red, // Changed from 'primary' to 'backgroundColor'
            ),
          ),
        ],
      ),
    );
  }
}
