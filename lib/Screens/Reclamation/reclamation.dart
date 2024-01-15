import 'dart:convert';

import 'package:flutter_auth/Screens/Reclamation/addReclamation.dart';
import 'package:flutter_auth/Screens/Reclamation/reclamationDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ReclamationPage extends StatefulWidget {
  final int userId;

  const ReclamationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ReclamationPageState createState() => _ReclamationPageState();
}

class _ReclamationPageState extends State<ReclamationPage> {
  late Future<List<Reclamation>> reclamationsFuture;

  @override
  void initState() {
    super.initState();
    reclamationsFuture = getReclamations(widget.userId);
  }

  static Future<List<Reclamation>> getReclamations(int userId) async {
    var url = Uri.parse("http://localhost:8081/reclamations/user/$userId");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);

      List<Reclamation> reclamations = [];

      for (var item in body) {
        reclamations.add(Reclamation.fromJson(item));
      }

      return reclamations;
    } else {
      throw Exception('Failed to load reclamations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Gérer les Reclamations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildCard('Les reclamations En Cours', 'EN COURS'),
                  buildCard('Les reclamations Validé', 'VALIDE'),
                  buildCard('Les reclamations Refus', 'REFUS'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReclamationCreationPage(userId: widget.userId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildCard(String title, String status) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<List<Reclamation>>(
            future: reclamationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final reclamations = snapshot.data!;
                return buildReclamationsTable(reclamations, status);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Text("No data available");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildReclamationsTable(List<Reclamation> reclamations, String status) {
    final filteredReclamations = reclamations
        .where((reclamation) => reclamation.status == status)
        .toList();

    // Define the color for different statuses
    Color statusColor = Colors.blue; // Default color for 'EN COURS'
    if (status == 'VALIDE') {
      statusColor = Colors.green;
    } else if (status == 'REFUS') {
      statusColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DataTable(
        columns: [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Service')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Motif')),
          DataColumn(label: Text('Status')),
        ],
        rows: filteredReclamations.map((reclamation) {
          return DataRow(
            cells: [
              DataCell(Text(reclamation.id.toString())),
              DataCell(Text(reclamation.service.service)),
              DataCell(Text(reclamation.motif)),
              DataCell(Text(reclamation.status)),
              DataCell(
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecDetails(
                            userId: widget.userId, idB: reclamation.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class Reclamation {
  final int id;
  final String motif;
  final String motifMgr;
  final String status;
  final Service service;

  Reclamation({
    required this.id,
    required this.motif,
    required this.motifMgr,
    required this.status,
    required this.service,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: json['id'] ?? 0, // Replace 0 with the default value you want for 'id'
      motif:
          json['motif'] ?? '', // Replace '' with the default value for 'motif'
      motifMgr: json['motifMgr'] ??
          '', // Replace '' with the default value for 'motifMgr'
      status: json['status'] ??
          '', // Replace '' with the default value for 'status'
      service: Service.fromJson(json['service'] ??
          {}), // Replace {} with the default value for 'service'
    );
  }
}

class Service {
  final String service;

  Service({required this.service});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      service: json['service'],
    );
  }
}

class User {
  final String username;

  User({required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;

  const Badge({Key? key, required this.text, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}