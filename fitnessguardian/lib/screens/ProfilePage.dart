// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            // Profile Details
            Text(
              'User Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'user@example.com',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            // Profile Actions
            ElevatedButton(
              onPressed: () {
                // Handle edit button click
                print('Edit button clicked');
              },
              child: Text('Edit'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle save button click
                print('Save button clicked');
              },
              child: Text('Save'),
            ),
            SizedBox(height: 10),
            // Profile Settings
            ListTile(
              title: Text('Setting 1'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 1 click
                print('Setting 1 clicked');
              },
            ),
            Divider(height: 4),
            ListTile(
              title: Text('Setting 2'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 2 click
                print('Setting 2 clicked');
              },
            ),
            Divider(height: 4),
            ListTile(
              title: Text('Setting 3'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 3 click
                print('Setting 3 clicked');
              },
            ),
            Divider(height: 4),
            ListTile(
              title: Text('Setting 4'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle setting 4 click
                print('Setting 4 clicked');
              },
            ),
            Divider(height: 4),
          ],
        ),
      ),
    );
  }
}
