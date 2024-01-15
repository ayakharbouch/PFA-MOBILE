import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ReclamationPage extends StatefulWidget {
  const ReclamationPage({Key? key, required userId}) : super(key: key);

  @override
  _ReclamationPageState createState() => _ReclamationPageState();
}

class _ReclamationPageState extends State<ReclamationPage> {
  Future<List<Reclamation>> reclamationsFuture = getReclamations();

  static Future<List<Reclamation>> getReclamations() async {
    var url = Uri.parse("http://localhost:8081/reclamations/all");
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
                SizedBox(width: 10),
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
                  buildCard('Les reclamations En Cours', 'EN COURS', const Color.fromARGB(255, 238, 241, 243), Colors.blue),
                  buildCard('Les reclamations Validé', 'VALIDE', const Color.fromARGB(255, 245, 248, 245),Colors.green),
                  buildCard('Les reclamations Refus', 'REFUS', const Color.fromARGB(255, 254, 253, 252),Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String status, Color statusColor, Color textColor) {
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
                return buildReclamationsTable(reclamations, status, statusColor);
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

  Widget buildReclamationsTable(List<Reclamation> reclamations, String status, Color statusColor) {
    final filteredReclamations = reclamations
        .where((reclamation) => reclamation.status == status)
        .toList();

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
                    // Handle action button tap
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
      id: json['id'],
      motif: json['motif'],
      motifMgr: json['motifMgr'],
      status: json['status'],
      service: Service.fromJson(json['service']),
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