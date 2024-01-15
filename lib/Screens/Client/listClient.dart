import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Client/addClient.dart';
import 'package:flutter_auth/Screens/Client/editClient.dart';
import 'package:flutter_auth/components/sideMenu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListClientPage extends StatefulWidget {
  final int userId;
  ListClientPage({required this.userId});
  @override
  _ListClientPageState createState() => _ListClientPageState(userId: userId);
}

class _ListClientPageState extends State<ListClientPage> {
   final int userId;
   _ListClientPageState({required this.userId});
  List<Map<String, dynamic>> clients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the list of clients when the widget is initialized
    fetchClients();
  }

  Future<void> fetchClients() async {
    final response = await http.get(
      Uri.parse('http://localhost:8081/user/all'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        clients = List<Map<String, dynamic>>.from(data);
      });
    } else {
      // Handle error if needed
      print('Failed to fetch clients');
    }
  }

  List<Map<String, dynamic>> _filteredClients = [];

  void _filterClients() {
    final searchTerm = searchController.text.toLowerCase();
    _filteredClients = clients.where((client) {
      final email = client['email'].toString().toLowerCase();
      final matricule = client['cin'].toString().toLowerCase();
      return email.contains(searchTerm) || matricule.contains(searchTerm);
    }).where((client) {
      final roles = client['roles'];
      return roles != null &&
          roles.any((role) => role['name'] == 'ROLE_USER');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    _filterClients();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Clients'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddClientPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SideMenu(userId: userId),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  _filterClients();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Clients',
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
                  rows: _filteredClients
                      .map(
                        (client) => DataRow(
                          cells: [
                            DataCell(Text(client['email'] ?? '')),
                            DataCell(Text(client['cin'] ?? '')),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditClientPage(
                                            id: client['id']
                                                .toString()), // Pass the client's ID to EditClientPage
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
                                              'Are you sure you want to delete this client?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteClient(client['id']);
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

  Future<void> deleteClient(String id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:8081/user/deleteUser/$id'),
    );

    if (response.statusCode == 200) {
      print('Client deleted successfully');
      await Future.delayed(Duration(seconds: 1));
      fetchClients();
    } else {
      print('Failed to delete client. Status code: ${response.statusCode}');
    }
  }
}
