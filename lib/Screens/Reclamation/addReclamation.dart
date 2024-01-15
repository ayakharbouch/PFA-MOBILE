import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ReclamationCreationPage extends StatefulWidget {
  final int userId;

  ReclamationCreationPage({required this.userId});

  @override
  _ReclamationCreationPageState createState() =>
      _ReclamationCreationPageState();
}

class _ReclamationCreationPageState extends State<ReclamationCreationPage> {
  TextEditingController motifController = TextEditingController();
  TextEditingController commentaireController = TextEditingController();
  TextEditingController motifMgrController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  File? selectedFile;
  Uint8List? selectedFileBytes;
  List<Service> services = [];
  Service selectedService = Service(id: 0, name: ''); // Add this line

  @override
  void initState() {
    super.initState();
    // Fetch services when the widget is initialized
    fetchServices();
    // Example: Set the user ID when the user logs in
  }

  Future<void> fetchServices() async {
    try {
      String servicesUrl = "http://localhost:8081/services/all";

      var response = await http.get(Uri.parse(servicesUrl));

      if (response.statusCode == 200) {
        // Parse the response body to get a list of services
        List<dynamic> servicesJson = jsonDecode(response.body);
        setState(() {
          services =
              servicesJson.map((json) => Service.fromJson(json)).toList();
        });
      } else {
        print('Failed to fetch services. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching services: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Reclamation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: motifController,
              decoration: InputDecoration(labelText: 'Motif'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: commentaireController,
              decoration: InputDecoration(labelText: 'Commentaire'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SizedBox(height: 10),
            DropdownButton<Service>(
              value: services.isNotEmpty ? services.first : null,
              onChanged: (Service? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedService = newValue;
                  });
                }
              },
              items: services.map((Service service) {
                return DropdownMenuItem<Service>(
                  value: service,
                  child: Text(service.name),
                );
              }).toList(),
              hint: Text('Choose Service'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    selectedFile = File.fromRawPath(result.files.single.bytes!);
                    selectedFileBytes = result.files.single.bytes;
                  });
                }
              },
              child: Text('Pick File'),
            ),
            SizedBox(height: 20),
            if (selectedFile != null) ...[
              Text(
                'Selected File: ${selectedFile!.path.split('/').last}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
            ElevatedButton(
              onPressed: () {
                createReclamation();
                Navigator.pop(context, true); // Pass true as a result
              },
              child: Text('Create Reclamation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createReclamation() async {
    try {
      String url = "http://localhost:8081/reclamations/save_client";

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['motif'] = motifController.text;
      request.fields['criticite'] = true.toString();
      request.fields['commentaire'] = commentaireController.text;
      request.fields['status'] = 'EN COURS';
      request.fields['service'] = selectedService.id.toString();
      request.fields['user'] = widget.userId.toString(); // Use the user ID here

      if (selectedFile != null) {
        // Check if running on web or mobile and handle the file accordingly
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'pieceJointe',
            selectedFileBytes!,
            filename: 'selected_file',
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath(
            'pieceJointe',
            selectedFile!.path,
          ));
        }
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Reclamation created successfully');
      } else {
        print(
            'Failed to create reclamation. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error creating reclamation: $error');
    }
  }
}

class Service {
  final int id;
  final String name;

  Service({required this.id, required this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      name: json['service'] ?? '',
    );
  }
}