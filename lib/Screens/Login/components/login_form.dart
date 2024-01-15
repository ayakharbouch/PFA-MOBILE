import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Dashboard/dashboard.dart';
import 'package:flutter_auth/Screens/Dashboard/dashboardm.dart';
import 'package:flutter_auth/Screens/Reclamation/reclamation.dart';


import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginForm extends StatelessWidget {
  final int userId;

  const LoginForm({Key? key,  required this.userId}) : super(key: key);

  Future<void> login(
      String username, String password, BuildContext context) async {
    if (username.isEmpty || password.isEmpty) {
      // Show error message for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both username and password.'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final Uri apiUrl = Uri.parse('http://localhost:8081/api/auth/signin');
    try {
      final response = await http.post(
        apiUrl,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Successful login
        final responseData = jsonDecode(response.body);
        final token =
            responseData['token']; // Assuming token key in the response
        final roles =
            responseData['roles']; // Assuming roles key in the response

        if (roles.contains('ROLE_ADMIN')) {
          // Redirect to admin page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Dashboard(userId: userId), // Replace with your admin page widget
            ),
          );
        } else {
          final userId = responseData[
              'id']; // Assuming 'userId' is the key for the user ID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReclamationPage(userId: userId),//Dashboardm(userId: userId ), // Replace with your user page widget
            ),
          );
        }
      } else {
        final errorMessage = responseData[
            'message']; // Assuming error message key in the response
        if (errorMessage.contains('Invalid Password')) {
          // Show error message for incorrect password
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid password. Please try again.'),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          // Show general login failed message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please try again.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception during login. Please check your network.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Form(
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: "Your Username",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              final String username = usernameController.text;
              final String password = passwordController.text;

              login(username, password, context); // Call the login function
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  SignUpScreen(userId : userId);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}