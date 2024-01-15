import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData(widget.userId);
  }

  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    final Uri apiUrl = Uri.parse('http://localhost:8081/user/user/$userId');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      try {
        if (response.body.isNotEmpty) {
          Map<String, dynamic> decodedData = jsonDecode(response.body);
          if (decodedData != null &&
              decodedData.containsKey('id') &&
              decodedData.containsKey('username') &&
              decodedData.containsKey('email')) {
            return decodedData;
          } else {
            throw Exception('Invalid response format');
          }
        } else {
          throw Exception('Empty response body');
        }
      } catch (e) {
        throw Exception('Failed to decode response: $e');
      }
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            'https://cdn.shopify.com/s/files/1/0045/5104/9304/t/27/assets/AC_ECOM_SITE_2020_REFRESH_1_INDEX_M2_THUMBS-V2-1.jpg?v=8913815134086573859'),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        'Username:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['username'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Nom:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['nom'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Prenom:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['prenom'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['email'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'CIN:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        user['cin'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the edit profile page (if you have one)
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
