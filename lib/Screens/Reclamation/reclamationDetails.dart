import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Reclamation/reclamation.dart';

import 'package:http/http.dart' as http;

class RecDetails extends StatefulWidget {
  final int idB;
  final int userId;

  const RecDetails({Key? key, required this.userId, required this.idB})
      : super(key: key);

  @override
  _RecDetailsState createState() => _RecDetailsState();
}

class _RecDetailsState extends State<RecDetails> {
  late Future<Reclamation> reclamationFuture;

  @override
  void initState() {
    super.initState();
    reclamationFuture = getReclamationDetails(widget.idB);
  }

  Future<Reclamation> getReclamationDetails(int id) async {
    var url = Uri.parse("http://localhost:8081/reclamations/reclamation/$id");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);

      return Reclamation.fromJson(body);
    } else {
      throw Exception('Failed to load reclamation details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reclamation Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ReclamationPage(userId: widget.userId),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Reclamation>(
          future: reclamationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final reclamation = snapshot.data!;
              return buildReclamationDetails(reclamation);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  Widget buildReclamationDetails(Reclamation reclamation) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reclamation ID: ${reclamation.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Motif: ${reclamation.motif}'),
            Text('Motif Manager: ${reclamation.motifMgr}'),
            Text('Status: ${reclamation.status}'),
            SizedBox(height: 10),
            ExpansionTile(
              title: Text('Service Details'),
              children: [
                ListTile(
                  title: Text('Service: ${reclamation.service.service}'),
                ),
                // Add more service details as needed
              ],
            ),
            Text('Commentaire: ${reclamation.commentaire}'),
            Text('Criticité : ${reclamation.criticite}'),
          ],
        ),
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
  final String commentaire;
  final bool criticite;

  Reclamation({
    required this.id,
    required this.motif,
    required this.motifMgr,
    required this.status,
    required this.service,
    required this.commentaire,
    required this.criticite,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: json['id'] ?? 0,
      motif: json['motif'] ?? '',
      motifMgr: json['motifMgr'] ?? '',
      status: json['status'] ?? '',
      service: Service.fromJson(json['service']),
      commentaire: json['commentaire'] ?? '',
      criticite: json['criticite'] ?? '',
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