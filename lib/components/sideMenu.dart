import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Client/listClient.dart';
import 'package:flutter_auth/Screens/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/Manager/listManager.dart';
import 'package:flutter_auth/Screens/Profile/profilepage.dart';

class SideMenu extends StatelessWidget {
  final int userId;
  const SideMenu({Key? key, required this.userId}) : super(key: key);
  
  
  
 

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
                  builder: (context) => Dashboard(userId: userId), // Replace with your DashboardPage
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.asset('assets/icons/client.png', width: 24, height: 24),
            title: Text('User Profile'),
            onTap: () async {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: userId),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.asset('assets/icons/manager.png', width: 24, height: 24),
            title: Text('Gestion Manager'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListManagerPage(userId : userId),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Image.asset('assets/icons/client.png', width: 24, height: 24),
            title: Text('Liste des Clients'),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListClientPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  
}
