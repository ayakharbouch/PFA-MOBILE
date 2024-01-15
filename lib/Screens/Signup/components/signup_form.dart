import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
 final int userId;
  SignUpForm({
    Key? key, required this.userId
}) : super(key: key);

  Future<void> signUp(String username, String email, String password,
      BuildContext context) async {
    final Uri apiUrl = Uri.parse('http://localhost:8081/api/auth/signup');
    try {
      final response = await http.post(
        apiUrl,
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Handle successful signup
        print('Signed up successfully');
        // Show green notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signed up successfully!',
              style: TextStyle(
                color: Colors.green, // Set the text color to green
                fontWeight:
                    FontWeight.bold, // You can add additional styles if needed
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear text fields upon successful signup
        usernameController.clear();
        emailController.clear();
        passwordController
            .clear(); // You can navigate to another screen or perform actions here upon successful signup
      } else {
        final errorMessage = responseData[
            'message']; // Assuming the error message is sent as 'message' from the backend

        if (errorMessage.contains('Username is already taken')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Username is already taken!',
                style: TextStyle(
                  color: Colors.red, // Set the text color to red
                  fontWeight: FontWeight
                      .bold, // You can add additional styles if needed
                ),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (errorMessage.contains('Email is already in use')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email is already in Use!',
                style: TextStyle(
                  color: Colors.red, // Set the text color to red
                  fontWeight: FontWeight
                      .bold, // You can add additional styles if needed
                ),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signup failed. Please try again.'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception during signup. Please check your network.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your username",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Your password",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () {
              final String username = usernameController.text;
              final String email = emailController.text;
              final String password = passwordController.text;

              final usernameError =
                  username.isEmpty ? 'Please enter your username' : null;
              final emailError = email.isEmpty || !email.contains('@')
                  ? 'Please enter a valid email address'
                  : null;
              final passwordError = password.isEmpty || password.length < 8
                  ? 'Password must be at least 8 characters'
                  : null;

              if (usernameError == null &&
                  emailError == null &&
                  passwordError == null) {
                signUp(username, email, password,
                    context); // Call the signup function
              } else {
                // Show error messages in the UI
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        usernameError ?? emailError ?? passwordError ?? ''),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
