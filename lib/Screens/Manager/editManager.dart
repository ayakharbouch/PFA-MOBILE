import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditManagerPage extends StatefulWidget {
  final String id; // The ID of the manager you want to edit

  EditManagerPage({required this.id});

  @override
  _EditManagerPageState createState() => _EditManagerPageState();
}

class _EditManagerPageState extends State<EditManagerPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController matriculeController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: matriculeController,
                decoration: InputDecoration(labelText: 'Matricule'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a matricule';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: prenomController,
                decoration: InputDecoration(labelText: 'Prenom'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a prenom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true, // Mask the password
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateManager();
                  }
                },
                child: Text('Update Manager'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateManager() async {
    // Prepare the updated data
    Map<String, dynamic> updatedData = {
      'email': emailController.text,
      'matricule': matriculeController.text,
      'nom': nomController.text,
      'prenom': prenomController.text,
      'username': usernameController.text,
      'password': passwordController.text, 
    };

    try {
      // Send the update request to the backend
      final response = await http.put(
        Uri.parse('http://localhost:8081/user/updateUser/${widget.id}'),
        body: updatedData,
      );

      if (response.statusCode == 200) {
        // Successful update
        // You can handle the success scenario as needed
        print('Manager updated successfully');
        // You might want to navigate back to the list page or show a success message
      } else {
        // Handle the error scenario
        print('Failed to update manager. Status code: ${response.statusCode}');
        // You might want to show an error message to the user
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error during update: $e');
    }
  }
}
