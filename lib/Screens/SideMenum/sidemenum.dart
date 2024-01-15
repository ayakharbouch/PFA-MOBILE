import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Dashboard/dashboardm.dart';

import 'package:flutter_auth/Screens/Reclamation/reclamationpage.dart';

class sidemenum extends StatelessWidget {
   final int userId;
  const sidemenum({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'User Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(Icons.dashboard, size: 24), // Replace with your desired icon
            title: Text('Dashboard'),
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboardm(userId:userId), // Replace with your DashboardPage
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.asset('assets/icons/client.png', width: 24, height: 24),
            title: Text('User Profile'),
            onTap: () {
              // Navigate to the user profile page
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.asset('assets/icons/manager.png', width: 24, height: 24),
            title: Text('Gestion des Réclamation'),
            onTap: () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReclamationPage(userId: ''),
                ),);
            },

          ),
          
        ],
      ),
    );
  }
}
