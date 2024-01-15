import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Implement logout logic here
            // For example, navigate back to the login page
            Navigator.pop(
                context); // Go back to the previous screen (login screen)
          },
        ),
      ),
      body: Center(
        child: Text(
          'USER PAGE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
