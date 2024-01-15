import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Manager/addManager.dart';
import 'package:flutter_auth/Screens/Manager/editManager.dart';
import 'package:flutter_auth/components/sideMenu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListManagerPage extends StatefulWidget {
  final int userId;
    ListManagerPage({required this.userId});
  @override
  _ListManagerPageState createState() => _ListManagerPageState(userId: userId);
}

class _ListManagerPageState extends State<ListManagerPage> {
    final int userId;
   _ListManagerPageState({required this.userId});
  List<Map<String, dynamic>> managers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the list of managers when the widget is initialized
    fetchManagers();
  }

  Future<void> fetchManagers() async {
    final response = await http.get(
      Uri.parse('http://localhost:8081/user/all'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        managers = List<Map<String, dynamic>>.from(data);
      });
    } else {
      // Handle error if needed
      print('Failed to fetch managers');
    }
  }

  List<Map<String, dynamic>> _filteredManagers = [];

  void _filterManagers() {
    final searchTerm = searchController.text.toLowerCase();
    _filteredManagers = managers.where((manager) {
      final email = manager['email'].toString().toLowerCase();
      final matricule = manager['cin'].toString().toLowerCase();
      return email.contains(searchTerm) || matricule.contains(searchTerm);
    }).where((manager) {
      final roles = manager['roles'];
      return roles != null &&
          roles.any((role) => role['name'] == 'ROLE_MODERATOR');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _filterManagers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Managers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddManagerPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(userId: userId), // Added SideMenu
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  // Trigger filter when search input changes
                  _filterManagers();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Managers',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Matricule')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _filteredManagers
                      .map(
                        (manager) => DataRow(
                          cells: [
                            DataCell(Text(manager['email'] ?? '')),
                            DataCell(Text(manager['cin'] ?? '')),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditManagerPage(
                                            id: manager['id']
                                                .toString()), // Pass the manager's ID to EditManagerPage
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete this manager?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // Dismiss the dialog
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Call the function to delete the manager
                                                deleteManager(manager['id']);
                                                // Dismiss the dialog
                                                Navigator.pop(context);
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            )),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteManager(String id) async {
    
      final response = await http.delete(
        Uri.parse('http://localhost:8081/user/deleteUser/$id'),
      );

     if (response.statusCode == 200) {
  // Successful delete
  // You can handle the success scenario as needed
  print('Manager deleted successfully');
  // Delay or await here before fetching again
  await Future.delayed(Duration(seconds: 1)); // Example delay
  fetchManagers(); // Refresh the list after deletion
} else {
  // Handle the error scenario
  print('Failed to delete manager. Status code: ${response.statusCode}');
  // You might want to show an error message to the user
}
  }
}