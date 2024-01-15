import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddManagerPage extends StatefulWidget {
  @override
  _AddManagerPageState createState() => _AddManagerPageState();
}

class _AddManagerPageState extends State<AddManagerPage> {
  final _formKey = GlobalKey<FormState>();
    String _email = ''; // Initialize with empty string
  String _password = ''; // Initialize with empty string
  String _matricule = ''; // Initialize with empty string
  String _username ='';
  String _prenom='';
  String _nom ='';

  Future<void> _addManager() async {
    final response = await http.post(
      Uri.parse('http://localhost:8081/user/save-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': _email,
        'password': _password,
        'matricule': _matricule,
        'username': _username,
        'prenom': _prenom,
        'nom': _nom,
        // Add other fields as needed
      }),
    );

    if (response.statusCode == 200) {
      // Manager added successfully, you can handle the response if needed
      print('Manager added successfully');
    } else {
      // Error in adding manager, you can handle the error if needed
      print('Failed to add manager');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Ajouter un Nouveau Manager'),
    ),
    body: Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centered content vertically
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
                onSaved: (value) => _nom = value!,
              ),
              SizedBox(height: 8.0), // Add some spacing
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
                onSaved: (value) => _prenom = value!,
              ),
              SizedBox(height: 8.0), // Add some spacing
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              SizedBox(height: 8.0), // Add some spacing
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'EMAIL',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 8.0), // Add some spacing
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'PASSWORD',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 8.0), // Add some spacing
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'N° DE MATRICULE',
                  border: InputBorder.none, // Remove border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de matricule';
                  }
                  return null;
                },
                onSaved: (value) => _matricule = value!,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addManager(); // Call the function to add manager
                  }
                },
                child: Text('ENREGISTRER'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}